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
	for i in 2:n #spare the first element so that the phase begins with zero
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



#
# allandev - calculates the normal or overlapping allan deviation
#
# parameters:
# <data>:		the data array to calculate the deviation from either as as phases or frequencies
# <rate>:		the rate of the data given
# [datatype]:	the type of data as either `phase` (default) or `frequency`
# [stride]:		the stride to calculate with as either `overlapping` (default) or `consecutive`
# [taus]:		the taus to calculate at as either a descriptor with `all`,
#				`octave` (default) for log2 spacing, `decade` for log10 spacing, a float array with given taus
#				or a single float as a custom log scale greater 1.0
#
# returns: named tupple (taus, deviation, error, count)
# `taus`:		the taus which where calculated
# `deviation`:	the allan deviations
# `error`:		the error of the deviations
# `count`:		number of contributing terms for the deviations
#
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
	for (index, τ) in enumerate(m)

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
	(taus = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end




#
# mdallandev - calculates the normal or overlapping modified allan deviation
#
# parameters:
# <data>:		the data array to calculate the deviation from either as as phases or frequencies
# <rate>:		the rate of the data given
# [datatype]:	the type of data as either `phase` (default) or `frequency`
# [stride]:		the stride to calculate with as either `overlapping` (default) or `consecutive`
# [taus]:		the taus to calculate at as either a descriptor with `all`,
#				`octave` (default) for log2 spacing, `decade` for log10 spacing, a float array with given taus
#				or a single float as a custom log scale greater 1.0
#
# returns: named tupple (taus, deviation, error, count)
# `taus`:		the taus which where calculated
# `deviation`:	the modified allan deviations
# `error`:		the error of the deviations
# `count`:		number of contributing terms for the deviations
#
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
	for (index, τ) in enumerate(m)

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
	(taus = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end




#
# hadamarddev - calculates the normal or overlapping hadamard deviation
#
# parameters:
# <data>:		the data array to calculate the deviation from either as as phases or frequencies
# <rate>:		the rate of the data given
# [datatype]:	the type of data as either `phase` (default) or `frequency`
# [stride]:		the stride to calculate with as either `overlapping` (default) or `consecutive`
# [taus]:		the taus to calculate at as either a descriptor with `all`,
#				`octave` (default) for log2 spacing, `decade` for log10 spacing, a float array with given taus
#				or a single float as a custom log scale greater 1.0
#
# returns: named tupple (taus, deviation, error, count)
# `taus`:		the taus which where calculated
# `deviation`:	the hadamard deviations
# `error`:		the error of the deviations
# `count`:		number of contributing terms for the deviations
#
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
	for (index, τ) in enumerate(m)

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
	(taus = m[selector] ./ rate, deviation = dev[selector], error = deverr[selector], count = devcount[selector])
end




#
# timedev - calculates the normal or overlapping time deviation
#
# parameters:
# <data>:		the data array to calculate the deviation from either as as phases or frequencies
# <rate>:		the rate of the data given
# [datatype]:	the type of data as either `phase` (default) or `frequency`
# [stride]:		the stride to calculate with as either `overlapping` (default) or `consecutive`
# [taus]:		the taus to calculate at as either a descriptor with `all`,
#				`octave` (default) for log2 spacing, `decade` for log10 spacing, a float array with given taus
#				or a single float as a custom log scale greater 1.0
#
# returns: named tupple (taus, deviation, error, count)
# `taus`:		the taus which where calculated
# `deviation`:	the time deviations
# `error`:		the error of the deviations
# `count`:		number of contributing terms for the deviations
#
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

	(taus = mdtaus, deviation = mdm .* mddeviation, error = mdm .* mderror, count = mdcount)
end




#
# /Exported functions
#



end # AllanDeviations
