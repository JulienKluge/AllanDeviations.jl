"""
hadamarddev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the hadamard deviation

#parameters:
* `<data>`:			The data array to calculate the deviation from either as as phases or frequencies.
* `<rate>`:			The rate of the data given.
* `[frequency]`:		True if `data` contains frequency data otherwise (default) phase data is assumed.
* `[overlapping]`:	True (default) to calculate overlapping deviation, false otherwise.
* `[taus]`:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type `AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave`, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.

#returns: named tupple (tau, deviation, error, count)
* `tau`:		Taus which where used.
* `deviation`:	Deviations calculated.
* `error`:		Respective errors.
* `count`:		Number of contributing terms for each deviation.
"""
function hadamarddev(
		data::Array{T, 1},
		rate::AbstractFloat;
		frequency::Bool = false,
		overlapping::Bool = true,
		taus::Union{Type{U}, Integer, AbstractFloat, Array{Float64}} = 192) where {T, U <: AllanTauDescriptor}

	#frequency to phase calculation
	if frequency
		data = frequencytophase(data, rate)
	end

	n = length(data)
	if n < 5
		error("Length for `data` in hadamarddev must be at least 5 or greater")
	end

	#tau calculations
	m = taudescription_to_m(taus, rate, n)

	dev = zeros(T, length(m)) #hadamarddeviation
	deverr = zeros(T, length(m)) #hadamarddeviation error
	devcount = zeros(Int, length(m)) #sum term count

	mStride = 1 #overlapping - can be overwritten in loop for consecutive
	@inbounds for (index, τ) in enumerate(m)

		if !overlapping #overwrite stride for consecutive operation
			mStride = τ
		end

		#hadamard deviation: http://www.leapsecond.com/tools/adev_lib.c
		sum = zero(T)
		i = 1
		terms = 0
		while (i + 3 * τ) <= n
			v = data[i + 3 * τ] - 3 * data[i + 2 * τ] + 3 * data[i + τ] - data[i]
			sum += v * v
			i += mStride
			terms += 1
		end
		if terms <= 1 #break the tau loop if no contribution with term-count > 1 is done
			break
		end

		dev[index] = sqrt(sum / (6 * terms)) / τ * rate
		deverr[index] = dev[index] / sqrt(terms)
		devcount[index] = terms
	end

	selector = devcount .> 1 #select only entries, where 2 or more terms contributed to the deviation
	(tau = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end
