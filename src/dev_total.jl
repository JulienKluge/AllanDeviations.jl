"""
totaldev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the total deviation

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
function totaldev(
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
	if n < 3
		error("Length for `data` in totaldev must be at least 3 or greater")
	end

	if !overlapping #warn for consecutive execution
		@warn "It is highly unusual to use the total deviation in the non overlapping form. Do not use this for definite interpretation or publication."
	end

	#tau calculations
	m = taudescription_to_m(taus, rate, n)

	#array reflection
	dataPrime = zeros(Float64, 3 * n - 4)
	datStart = 2 * data[1]
	datEnd = 2 * data[n]
	nm2 = n - 2
	@inbounds for i = 1:nm2
		dataPrime[i          ] = datStart - data[n - i]	#left reflection
		dataPrime[i + nm2    ] = data[i]				#original data from 1 to (n - 2)
		dataPrime[i + nm2 + n] = datEnd - data[n - i]	#right reflection
	end
	dataPrime[2 * nm2 + 1] = data[n - 1]				#original data (n - 1)
	dataPrime[2 * nm2 + 2] = data[n]					#original data (n)

	dev = zeros(T, length(m)) #totaldev
	deverr = zeros(T, length(m)) #totaldev error
	devcount = zeros(Int, length(m)) #sum term count

	mStride = 1 #overlapping - can be overwritten in loop for consecutive
	@inbounds for (index, τ) in enumerate(m)

		if n - τ < 1
			break
		end

		if !overlapping #overwrite stride for consecutive operation
			mStride = τ
		end

		#hadamard deviation: http://www.leapsecond.com/tools/adev_lib.c
		sum = zero(T)
		i = n
		terms = 0
		while (i <= nm2 + n - 1)
			v = dataPrime[i - τ] - 2 * dataPrime[i] + dataPrime[i + τ]
			sum += v * v
			i += mStride
			terms += 1
		end
		if terms <= 1 #break the tau loop if no contribution with term-count > 1 is done
			break
		end

		dev[index] = sqrt(sum / (2 * terms)) / τ * rate
		deverr[index] = dev[index] / sqrt(terms)
		devcount[index] = terms
	end

	selector = devcount .> 1 #select only entries, where 2 or more terms contributed to the deviation
	(tau = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end
