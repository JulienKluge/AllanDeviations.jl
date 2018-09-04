using Test
using AllanDeviations
using Random

arrInt = zeros(Int, 5)
arr32 = zeros(Float32, 5)
arr64 = zeros(Float64, 5)

resInt = allandev(arrInt, 1.0, taus = AllTaus)
res32 = allandev(arr32, 1.0, taus = AllTaus)
res64 = allandev(arr64, 1.0, taus = AllTaus)



#Basic result type test
@test isa(resInt.deviation, Array{Int})
@test isa(res32.deviation, Array{Float32})
@test isa(res64.deviation, Array{Float64})
@test isa(res32.tau, Array{Float64})
@test isa(res64.tau, Array{Float64})
@test isa(res32.error, Array{Float32})
@test isa(res64.error, Array{Float64})
@test isa(res32.count, Array{Int})
@test isa(res64.count, Array{Int})



#Allandev from zero arrays is zero
@test sum(res32.deviation) == 0
@test sum(res64.deviation) == 0
#which also holds then for their errors
@test sum(res32.error) == 0
@test sum(res64.error) == 0



#and the result should be the same lenth for both types
@test length(res32.deviation) == length(res64.deviation)
@test length(res32.error) == length(res64.error)
@test length(res32.tau) == length(res64.tau)
@test length(res32.count) == length(res64.count)



#rate tests
arr64 = [1.0, 2.0, 1.0, 2.0, 1.5, 1.5, 2.0, 1.75]
res64 = allandev(arr64, 1.0)
res64r = allandev(arr64, 0.5)

@test sum(abs.(res64.deviation .- (2.0 .* res64r.deviation))) <= 2e-16 #half the rate means half the allan deviation
@test sum(abs.(res64.tau .- (0.5 .* res64r.tau))) <= 2e-16 #and double the tau
@test sum(abs.(res64.count .- res64r.count)) == 0 #but the count stays



#too few data points
@test_throws ErrorException allandev([1.0], 1.0)
@test_throws ErrorException allandev(zeros(Float64, 0), 1.0)
@test_throws ErrorException mallandev([1.0], 1.0)
@test_throws ErrorException hadamarddev([1.0], 1.0)
@test_throws ErrorException timedev([1.0], 1.0)
@test_throws ErrorException totaldev([1.0], 1.0)
@test_throws ErrorException mtie([1.0], 1.0)



#tau errors
@test_throws ErrorException allandev(arr64, 1.0, taus = 1.0)
@test_throws ErrorException allandev(arr64, 1.0, taus = 0.5)
@test_throws ErrorException allandev(arr64, 1.0, taus = -2.0)



#result and comparison tests
resallan = allandev(arr64, 1.0, taus = AllTaus)
resmallan = mallandev(arr64, 1.0, taus = AllTaus)
reshadamard = hadamarddev(arr64, 1.0, taus = AllTaus)
restime = timedev(arr64, 1.0, taus = AllTaus)
restotal = totaldev(arr64, 1.0, taus = AllTaus)
resmtie1 = mtie(arr64, 1.0, taus = AllTaus)
resmtie2 = mtie([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0], 1.0, taus = AllTaus)
resmtie3 = mtie([8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0], 1.0, taus = AllTaus)

@test abs(resallan.deviation[1] - 0.97093168314425360) < 2e-16
@test abs(resallan.deviation[2] - 0.18221724671391565) < 2e-16
@test abs(resallan.deviation[3] - 0.20833333333333334) < 2e-16

@test abs(resmallan.deviation[1] - 0.9709316831442536) < 2e-16
@test abs(resmallan.deviation[2] - 0.0919975090242484) < 2e-16

@test abs(reshadamard.deviation[1] - 1.0616418102794056) < 2e-16
@test abs(reshadamard.deviation[2] - 0.1943203969393503) < 2e-16

@test abs(restime.deviation[1] - 0.56056766862807130) < 2e-16
@test abs(restime.deviation[2] - 0.10622957319984969) < 2e-16

@test abs(restotal.deviation[1] - 0.97093168314425360) < 2e-16
@test abs(restotal.deviation[2] - 0.35539004394233290) < 2e-16
@test abs(restotal.deviation[3] - 0.19982631347136330) < 2e-16
@test abs(restotal.deviation[4] - 0.27540216805004764) < 2e-16
@test abs(restotal.deviation[5] - 0.13919410907075053) < 2e-16
@test abs(restotal.deviation[6] - 0.14877975892797604) < 2e-16

@test length(resmtie1.deviation) == length(arr64) - 2
for i = 1:length(resmtie1.deviation)
	@test abs(resmtie1.deviation[i] - 1.0) < 2e-16
	@test abs(resmtie2.deviation[i] - i) < 2e-16
	@test abs(resmtie3.deviation[i] - i) < 2e-16
end

@test resallan.deviation[1] == resmallan.deviation[1] #first element of allan deviation and modified allan deviation is the same
@test abs(resallan.deviation[1] / sqrt(3) - restime.deviation[1]) < 2e-16 #first element of allan deviation and modified allan deviation is the same
@test reshadamard.count[1] < resallan.count[1] #the hadamarddeviation iterates over four terms
@test reshadamard.count[1] < resmallan.count[1] #the hadamarddeviation iterates over four terms
@test abs(resmallan.deviation[2] / sqrt(3) * 2 - restime.deviation[2]) < 2e-16 #test time deviation calculation



#overlapping tests
Random.seed!(0xA11E4DE71A7104_00)
arr64 = rand(512)
resallan = allandev(arr64, 1.0, taus = AllTaus).count
resallan_o = allandev(arr64, 1.0, overlapping = true, taus = AllTaus).count
resallan_c = allandev(arr64, 1.0, overlapping = false, taus = AllTaus).count
resmallan_o = mallandev(arr64, 1.0, overlapping = true, taus = AllTaus).count
resmallan_c = mallandev(arr64, 1.0, overlapping = false, taus = AllTaus).count
reshadamard_o = hadamarddev(arr64, 1.0, overlapping = true, taus = AllTaus).count
reshadamard_c = hadamarddev(arr64, 1.0, overlapping = false, taus = AllTaus).count
restotal_o = totaldev(arr64, 1.0, overlapping = true, taus = AllTaus).count
resmtie_o = mtie(arr64, 1.0, overlapping = true, taus = AllTaus).count

@test length(resallan) == length(resallan_o) #overlapping is standard
@test length(resallan_o) == 255
@test length(resallan_c) == 170
@test sum(resallan_o) == 65280
@test sum(resallan_c) == 2674

@test length(resmallan_o) == 170
@test length(resmallan_c) == 170
@test sum(resmallan_o) == 43605
@test sum(resmallan_c) == 2674

@test length(reshadamard_o) == 170
@test length(reshadamard_c) == 127
@test sum(reshadamard_o) == 43435
@test sum(reshadamard_c) == 2461

@test length(restotal_o) == 510
@test sum(restotal_o) == 260100

@test length(resmtie_o) == 510
@test sum(resmtie_o) == 130815



#frequency conversion tests
resallan = allandev(arr64, 1.0, taus = AllTaus)
resallan_p = allandev(arr64, 1.0, frequency = false, taus = AllTaus)
resallan_f = allandev(arr64, 1.0, frequency = true, taus = AllTaus)
resallan_f_r = allandev(arr64, 0.5, frequency = true, taus = AllTaus)
arr64_f = zeros(Float64, length(arr64) + 1)
arr64_f[2:length(arr64_f)] = cumsum(arr64)
arr64_f_r = zeros(Float64, length(arr64) + 1)
arr64_f_r[2:length(arr64_f)] = cumsum(arr64 * 2.0)
resallan_f_a = allandev(arr64_f, 1.0, frequency = false, taus = AllTaus)
resallan_f_a_r = allandev(arr64_f_r, 1.0, frequency = false, taus = AllTaus)

resmallan = mallandev(arr64, 1.0, frequency = true, taus = AllTaus)
reshadamard = hadamarddev(arr64, 1.0, frequency = true, taus = AllTaus)
restime = timedev(arr64, 1.0, frequency = true, taus = AllTaus)

@test sum(abs.(resallan.deviation .- resallan_p.deviation)) < 2e-16 #phase is standard
@test sum(abs.(resallan_p.deviation .- resallan_f.deviation)) > 2e-16 #frequency is not the same
@test sum(abs.(resallan_f.deviation .- resallan_f_a.deviation)) < 2e-13 #frequency conversion
@test sum(abs.(resallan_f_r.deviation .- (resallan_f_a_r.deviation .* 0.5))) < 2e-13 #frequency conversion with different rate

@test sum(abs(resallan_f.deviation[1] - resmallan.deviation[1])) < 2e-15 #also test for mallandev
@test abs(reshadamard.deviation[1] - 0.29893879132526296) < 2e-16 #hadamarddev
@test abs(restime.deviation[1] - 0.17291213240777910) < 2e-16 #timedev



#taus tests
resallan_a = allandev(arr64, 1.0, taus = AllTaus).count
resallan_qo = allandev(arr64, 1.0, taus = QuarterOctave).count
resallan_ho = allandev(arr64, 1.0, taus = HalfOctave).count
resallan_o = allandev(arr64, 1.0, taus = Octave).count
resallan_hd = allandev(arr64, 1.0, taus = HalfDecade).count
resallan_d = allandev(arr64, 1.0, taus = Decade).count

#all tau arguments
taus_o_a = 2.0 .^(0:floor(log2(length(arr64))))
resallan_o_c = allandev(arr64, 1.0, taus = 2.0).count
resallan_o_a = allandev(arr64, 1.0, taus = taus_o_a).count
#all tau arguments mallandev
resmallan = mallandev(arr64, 1.0, taus = Octave).count
resmallan_o_c = mallandev(arr64, 1.0, taus = 2.0).count
resmallan_o_a = mallandev(arr64, 1.0, taus = taus_o_a).count
#all tau arguments hadamarddev
reshadamard = hadamarddev(arr64, 1.0, taus = Octave).count
reshadamard_o_c = hadamarddev(arr64, 1.0, taus = 2.0).count
reshadamard_o_a = hadamarddev(arr64, 1.0, taus = taus_o_a).count


@test length(resallan_a) == 255
@test sum(resallan_a) == 65280

@test length(resallan_qo) == 21
@test sum(resallan_qo) == 8680

@test length(resallan_ho) == 13
@test sum(resallan_ho) == 5506

@test length(resallan_o) == 8
@test sum(resallan_o) == 3586
@test length(resallan_o_c) == 8 #float tau argument
@test sum(resallan_o_c) == 3586 #float tau argument
@test length(resallan_o_a) == 8 #array tau argument
@test sum(resallan_o_a) == 3586 #array tau argument

@test length(resallan_hd) == 4
@test sum(resallan_hd) == 1736

@test length(resallan_d) == 3
@test sum(resallan_d) == 1314

#mallandev tau tests
@test length(resmallan) == length(resmallan_o_c)
@test length(resmallan_o_a) == length(resmallan_o_c)
@test sum(resmallan) == sum(resmallan_o_c)
@test sum(resmallan_o_a) == sum(resmallan_o_c)

#hadamarddev tau tests
@test length(reshadamard) == length(reshadamard_o_c)
@test length(reshadamard_o_a) == length(reshadamard_o_c)
@test sum(reshadamard) == sum(reshadamard_o_c)
@test sum(reshadamard_o_a) == sum(reshadamard_o_c)
