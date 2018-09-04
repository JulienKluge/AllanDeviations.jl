#=
##
## TODO:	mtie has great performance for phase data but extremely worse performance for frequency data
##			Is this due to branch misprediction?
##
=#
"""
mtie(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the maximal time interval error

# parameters:
* `<data>`:			The data array to calculate the deviation from either as as phases or frequencies.
* `<rate>`:			The rate of the data given.
* `[frequency]`:	True if `data` contains frequency data otherwise (default) phase data is assumed.
* `[overlapping]`:	True (default) to calculate overlapping deviation, false otherwise.
* `[taus]`:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type `AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave`, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.

# returns: named tupple (tau, deviation, error, count)
* `tau`:		Taus which where used.
* `deviation`:	Deviations calculated.
* `error`:		Respective errors.
* `count`:		Number of contributing terms for each deviation.
"""
function mtie(
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
	if n < 2
		error("Length for `data` in mtie must be at least 2 or greater")
	end

	if !overlapping #warn for consecutive execution
		@warn "It is highly unusual to use the mtie in the non overlapping form. Do not use this for definite interpretation or publication."
	end

	#tau calculations
	m = taudescription_to_m(taus, rate, n)

	dev = zeros(T, length(m)) #mtie
	deverr = zeros(T, length(m)) #mtie error
	devcount = zeros(Int, length(m)) #sum term count

	mStride = 1 #overlapping - can be overwritten in loop for consecutive
	@inbounds for (index, τ) in enumerate(m)

		if !overlapping #overwrite stride for consecutive operation
			mStride = τ
		end

		#mtie: https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication1065.pdf
		terms = n - τ
		if terms < 2
			break
		end

		submin = data[1]
		submax = data[1]
		for j = 1:(1 + τ)
			if data[j] < submin
				submin = data[j]
			elseif data[j] > submax
				submax = data[j]
			end
		end
		delta = submax - submin
		maximumv = delta
		for i = (1 + mStride):(mStride):(n - τ)

			#max pipe
			if data[i - mStride] == submax #rolling max-pipe is obsolete
				submax = data[i]
				for j = i:(i + τ)
					if data[j] > submax
						submax = data[j]
					end
				end
				delta = submax - submin
			elseif data[i + τ] > submax #if new element is bigger than the old one
				submax = data[i + τ]
				delta = submax - submin
			end

			#min pipe
			if data[i - mStride] == submin #rolling min-pipe is obsolete
				submin = data[i]
				for j = i:(i + τ)
					if data[j] < submin
						submin = data[j]
					end
				end
				delta = submax - submin
			elseif data[i + τ] < submin #if new element is smaller than the old one
				submin = data[i + τ]
				delta = submax - submin
			end

			#comparer
			if delta > maximumv
				maximumv = delta
			end

		end

		dev[index] = maximumv
		deverr[index] = dev[index] / sqrt(terms)
		devcount[index] = terms
	end

	selector = devcount .> 1 #select only entries, where 2 or more terms contributed to the deviation
	(tau = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end
