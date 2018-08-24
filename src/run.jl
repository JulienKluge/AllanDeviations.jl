include("AllanDeviations.jl")

for i = 1:50
	print("-")
end
println()

#
#
#

a = sin.(collect(0:20))
t = [3.0, 4.0, 5.0]
(taus, allan, allanerror, allanN) = AllanDeviations.allandev(
									a,
									0.5,
									frequency = false,
									overlapping = true,
									taus = AllanDeviations.Octave
									)
println(allan)
println(collect(taus))
println(allanerror)
println(allanN)

@code_warntype AllanDeviations.allandev(zeros(Float32, 5), 1.0, frequency = false, overlapping = true)

