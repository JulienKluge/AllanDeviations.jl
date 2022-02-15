"""
mallandev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the modified allan deviation

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
function mallandev(
		data::AbstractArray{T, 1},
		rate::AbstractFloat;
		frequency::Bool = false,
		overlapping::Bool = true,
		taus::Union{Type{U}, Integer, AbstractFloat, Array{Float64}} = 192) where {T, U <: AllanTauDescriptor}

	#frequency to phase calculation
	if frequency
		data = frequencytophase(data, rate)
	end

	n = length(data)
	if n < 4
		error("Length for `data` in mallandev must be at least 4 or greater")
	end

	#tau calculations
	m = taudescription_to_m(taus, rate, n)

	dev = zeros(T, length(m)) #allandeviation
	deverr = zeros(T, length(m)) #allandeviation error
	devcount = zeros(Int, length(m)) #sum term count

	mStride = 1 #overlapping - can be overwritten in loop for consecutive
	@inbounds for (index, τ) in enumerate(m)

		if !overlapping #overwrite stride for consecutive operation
			mStride = τ
		end

		#allan deviation: http://www.leapsecond.com/tools/adev_lib.c
		sum = zero(T)
		v = zero(T)
		i = 1
		while (i + 2 * τ) <= n && i <= τ
			v += data[i] - 2 * data[i + τ] + data[i + 2 * τ]
			i += mStride
		end
		sum += v * v
		terms = 1
		i = 1
		while (i + 3 * τ) <= n
			v += data[i + 3 * τ] - 3 * data[i + 2 * τ] + 3 * data[i + τ] - data[i]
			sum += v * v
			i += mStride
			terms += 1
		end

		if terms <= 1 #break the tau loop if no contribution with term-count > 1 is done
			break
		end

		dev[index] = sqrt(sum / (2 * terms)) / (τ * τ) * rate
		deverr[index] = dev[index] / sqrt(terms)
		devcount[index] = terms
	end

	selector = devcount .> 1 #select only entries, where 2 or more terms contributed to the deviation
	(tau = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end
