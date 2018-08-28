module AllanDeviations

#
# Exports/
#
export AllanTauDescriptor, AllTaus, QuarterOctave, HalfOctave, Octave, HalfDecade, Decade

export allandev
export mallandev
export hadamarddev
export timedev
#
# /Exports
#



#
# Types/
#
abstract type AllanTauDescriptor end
struct AllTaus <: AllanTauDescriptor end
struct QuarterOctave <: AllanTauDescriptor end
struct HalfOctave <: AllanTauDescriptor end
struct Octave <: AllanTauDescriptor end
struct HalfDecade <: AllanTauDescriptor end
struct Decade <: AllanTauDescriptor end
#
# /Types
#



#
# Helper Functions/
#
function frequencytophase(data::Array{T, 1}, rate::AbstractFloat) where T
	dt = 1 / rate
	n = length(data) + 1
	dataPrime = zeros(T, n)
	walkingSum = zero(T)
	@inbounds for i in 2:n #spare the first element so that the phase begins with zero
		walkingSum += data[i - 1]
		dataPrime[i] = walkingSum * dt
	end
	dataPrime
end

#tau-descriptor to m
function taudescription_to_m(::Type{AllTaus}, rate::AbstractFloat, n::Int)
	1:(n - 2)
end
function taudescription_to_m(::Type{Decade}, rate::AbstractFloat, n::Int)
	10 .^(0:Int(floor(log10(n))))
end
function taudescription_to_m(::Type{HalfDecade}, rate::AbstractFloat, n::Int)
	5 .^(0:Int(floor(log(5.0, n))))
end
function taudescription_to_m(::Type{Octave}, rate::AbstractFloat, n::Int)
	2 .^(0:Int(floor(log2(n))))
end
function taudescription_to_m(::Type{HalfOctave}, rate::AbstractFloat, n::Int)
	unique(Int.(floor.(
		1.5 .^(0:Int(floor(log(1.5, n))))
		)))
end
function taudescription_to_m(::Type{QuarterOctave}, rate::AbstractFloat, n::Int)
	unique(Int.(floor.(
		1.25 .^(0:Int(floor(log(1.25, n))))
		)))
end
#tau with custom log base value to m
function taudescription_to_m(taus::AbstractFloat, rate::AbstractFloat, n::Int)
	if taus <= 1.0
		error("Custom `taus`-log scale must be greater than 1.0")
	end
	unique(Int.(floor.(
		taus .^(0:Int(floor(log(taus, n))))
		)))
end
#tau with custom array to m
function taudescription_to_m(taus::Array{Float64}, rate::AbstractFloat, n::Int)
	m = unique(Int.(floor.(rate .* taus)))
	m[m .>= 1]
end
#
# /Helper Functions
#



#
# Exported functions/
#



"""
allandev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the allan deviation

#parameters:
* <data>:			The data array to calculate the deviation from either as as phases or frequencies.
* <rate>:			The rate of the data given.
* [frequency]:		True if `data` contains frequency data otherwise (default) phase data is assumed.
* [overlapping]:	True (default) to calculate overlapping deviation, false otherwise.
* [taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type
					(AllTaus, Decadade, HalfDecade, Octave (default), HalfOctave, QuarterOctave), an array
					of taus to calculate at or a number to build a custom log-scale on.

#returns: named tupple (tau, deviation, error, count)
* `tau`:		Taus which where used.
* `deviation`:	Deviations calculated.
* `error`:		Respective errors.
* `count`:		Number of contributing terms for each deviation.
"""
function allandev(
		data::Array{T, 1},
		rate::AbstractFloat;
		frequency::Bool = false,
		overlapping::Bool = true,
		taus::Union{Type{U}, AbstractFloat, Array{Float64}} = 2.0) where {T, U <: AllanTauDescriptor}

	#frequency to phase calculation
	if frequency
		data = frequencytophase(data, rate)
	end

	n = length(data)
	if n < 3
		error("Length for `data` in allandev must be at least 3 or greater")
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
		i = 1
		terms = 0
		while (i + 2 * τ) <= n
			v = data[i] - 2 * data[i + τ] + data[i + 2 * τ]
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




"""
mallandev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the modified allan deviation

#parameters:
* <data>:			The data array to calculate the deviation from either as as phases or frequencies.
* <rate>:			The rate of the data given.
* [frequency]:		True if `data` contains frequency data otherwise (default) phase data is assumed.
* [overlapping]:	True (default) to calculate overlapping deviation, false otherwise.
* [taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type
					(AllTaus, Decadade, HalfDecade, Octave (default), HalfOctave, QuarterOctave), an array
					of taus to calculate at or a number to build a custom log-scale on.

#returns: named tupple (tau, deviation, error, count)
* `tau`:		Taus which where used.
* `deviation`:	Deviations calculated.
* `error`:		Respective errors.
* `count`:		Number of contributing terms for each deviation.
"""
function mallandev(
		data::Array{T, 1},
		rate::AbstractFloat;
		frequency::Bool = false,
		overlapping::Bool = true,
		taus::Union{Type{U}, AbstractFloat, Array{Float64}} = 2.0) where {T, U <: AllanTauDescriptor}

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




"""
hadamarddev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the hadamard deviation

#parameters:
* <data>:			The data array to calculate the deviation from either as as phases or frequencies.
* <rate>:			The rate of the data given.
* [frequency]:		True if `data` contains frequency data otherwise (default) phase data is assumed.
* [overlapping]:	True (default) to calculate overlapping deviation, false otherwise.
* [taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type
					(AllTaus, Decadade, HalfDecade, Octave (default), HalfOctave, QuarterOctave), an array
					of taus to calculate at or a number to build a custom log-scale on.

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
		taus::Union{Type{U}, AbstractFloat, Array{Float64}} = 2.0) where {T, U <: AllanTauDescriptor}

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




"""
timedev(data, rate; [frequency=false], [overlapping=true], [taus=Octave])
Calculates the time deviation

#parameters:
* <data>:			The data array to calculate the deviation from either as as phases or frequencies.
* <rate>:			The rate of the data given.
* [frequency]:		True if `data` contains frequency data otherwise (default) phase data is assumed.
* [overlapping]:	True (default) to calculate overlapping deviation, false otherwise.
* [taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type
					(AllTaus, Decadade, HalfDecade, Octave (default), HalfOctave, QuarterOctave), an array
					of taus to calculate at or a number to build a custom log-scale on.

#returns: named tupple (tau, deviation, error, count)
* `tau`:		Taus which where used.
* `deviation`:	Deviations calculated.
* `error`:		Respective errors.
* `count`:		Number of contributing terms for each deviation.
"""
function timedev(
		data::Array{T, 1},
		rate::AbstractFloat;
		frequency::Bool = false,
		overlapping::Bool = true,
		taus::Union{Type{U}, AbstractFloat, Array{Float64}} = 2.0) where {T, U <: AllanTauDescriptor}

	n = length(data)
	if n < 4
		error("Length for `data` in timedev must be at least 4 or greater")
		#we check this here, so that we can output the right function name in case of the error
	end

	(mdtaus, mddeviation, mderror, mdcount) = mallandev(data, rate, frequency = frequency, overlapping = overlapping, taus = taus)
	mdm = mdtaus ./ sqrt(3)

	(tau = mdtaus, deviation = mdm .* mddeviation, error = mdm .* mderror, count = mdcount)
end




#
# /Exported functions
#



end # AllanDeviations
