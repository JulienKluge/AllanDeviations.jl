module AllanDeviations

#
# Exports/
#
export AllanTauDescriptor, AllTaus, QuarterOctave, HalfOctave, Octave, HalfDecade, Decade

export allandev
export mallandev
export hadamarddev
export timedev
export totaldev
export mtie
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
		1.5 .^(1:Int(floor(log(1.5, n))))
		)))
end
function taudescription_to_m(::Type{QuarterOctave}, rate::AbstractFloat, n::Int)
	unique(Int.(floor.(
		1.25 .^(1:Int(floor(log(1.25, n))))
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
#tau with custom tau-length count
function taudescription_to_m(count::Integer, rate::AbstractFloat, n::Int)
	unique(Int.(floor.(
		1.125 .^(1:(log(1.125, n) / count):log(1.125, n))
		)))
end
#
# /Helper Functions
#



#
# Exported functions/
#



include("dev_allan.jl")
include("dev_mallan.jl")
include("dev_hadamard.jl")
include("dev_time.jl")
include("dev_total.jl")
include("dev_mtie.jl")



#
# /Exported functions
#



end # AllanDeviations
