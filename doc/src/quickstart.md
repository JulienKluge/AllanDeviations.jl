# Quickstart

## Installation
Install the package once in a Julia Console/REPL with:
```Julia
using Pkg
Pkg.add("AllanDeviations")
```

## Loading
The package can be loaded in every Julia program with a simple using directive
```Julia
using AllanDeviations
```

## Allan Deviation of random data
Print the overlapping Allan Deviation of one million random points with rate 1.0 at octave log-spaced taus:
```Julia
using AllanDeviations

arr = rand(Float64, 1_000_000)

result = allandev(arr, 1.0)

println(result.deviation)
```

## Other deviations
```Julia
result = allandev(arr, 1.0)    #Allan deviation
result = mallandev(arr, 1.0)   #Modified Allan deviation
result = hadamarddev(arr, 1.0) #Hadamard deviation
result = timedev(arr, 1.0)     #Time deviation
result = totaldev(arr, 1.0)    #Total deviation
result = mtie(arr, 1.0)        #Maximum time interval error
```

## Full Data result
Every deviation method returns a named tuple in the form `(tau, deviation, error, count)`
```Julia
println("Calculated taus:")
println(result.tau)

println("Calculated Deviations:")
println(result.deviation)

println("Calculated errors:")
println(result.error)

println("Calculated Term Number:")
println(result.count)
```

### Same Result via tuple deconstruction
The returned tuple can already be deconstructed into variables on return.
```Julia
(myTaus, myDeviation, myError, myCount) = allandev(arr, 1.0)
```

## Calculating on frequency data
AllanDeviations.jl assumes by default that the `data`-argument contains phase data. This can be changed by setting the optional named argument `frequency` to `true` for frequency data.
```Julia
result = allandev(arr, 1.0, frequency = true)
```

## Non-Overlapping
AllanDeviations.jl will by default calculate the overlapping deviations.
This can be changed by setting the optional named argument `overlapping` to `false`.
```Julia
result = allandev(arr, 1.0, overlapping = false)
```

## Addressing different taus
```Julia
#Key-Types
allandev(arr, 1.0, taus = AllTaus)       #all possible taus
allandev(arr, 1.0, taus = QuarterOctave) #quarter octave log-spaced
allandev(arr, 1.0, taus = HalfOctave)    #half octave log-spaced
allandev(arr, 1.0, taus = Octave)        #octave log-spaced
allandev(arr, 1.0, taus = HalfDecade)    #hald decade log-spaced
allandev(arr, 1.0, taus = Decade)        #decade log-spaced

#Explicit taus
allandev(arr, 1.0, taus = [2.0])           #calculate deviation at tau=2.0 if possible
allandev(arr, 1.0, taus = [2.0, 3.0, 4.0]) #calculate deviation at tau=2.0, tau=3.0 & tau=4.0 if possible

#Custom log scale
allandev(arr, 1.0, taus = 1.2) #calculate 1/5 of an octave log-spaced

#Custom log count
allandev(arr, 1.0, taus = 100) #calculate 100 log-spaced tau values between min and maximal possible tau
#This does not guarantee that 100 deviations will be calculated since some values will be discarded
#when less than two terms contributed to it
```

## Benchmark Deviations

#### Benchmark different overlapping deviations for one million datapoints and 200 taus
```Julia
using BenchmarkTools
arr = rand(Float64, 1_000_000);
@btime allandev(arr, 1.0, taus = 200);    #Allan Deviation
@btime mallandev(arr, 1.0, taus = 200);   #Modified Allan Deviation
@btime hadamarddev(arr, 1.0, taus = 200); #Hadamard Deviation
@btime timedev(arr, 1.0, taus = 200);     #Time Deviation
@btime totaldev(arr, 1.0, taus = 200);    #Total Deviation
@btime mtie(arr, 1.0, taus = 200);        #Maximum time interval error
println("Done")
```
Results
```
315.247 ms (52 allocations: 35.91 KiB) #Allan Deviation
309.990 ms (52 allocations: 35.28 KiB) #Modified Allan Deviation
278.230 ms (52 allocations: 35.28 KiB) #Hadamard Deviation
309.647 ms (57 allocations: 39.33 KiB) #Time Deviation
331.483 ms (54 allocations: 22.92 MiB) #Total Deviation
901.942 ms (52 allocations: 35.91 KiB) #Maximum time interval error
Done
```

For comparison, pythons allantools needs approximately
3.5 seconds for the Allan deviation, 6.5 seconds for the total deviation and
an indeterminate amount of time for mtie (to be fair, allantools also provides a fastmtie which seems to be currently unfinished though).

#### Benchmark different overlapping deviations for 10.000 data points and all possible taus:
```Julia
using BenchmarkTools
arr = rand(Float64, 10_000)
@btime allandev(arr, 1.0, taus = AllTaus);    #Allan Deviation
@btime mallandev(arr, 1.0, taus = AllTaus);   #Modified Allan Deviation
@btime hadamarddev(arr, 1.0, taus = AllTaus); #Hadamard Deviation
@btime timedev(arr, 1.0, taus = AllTaus);     #Time Deviation
@btime totaldev(arr, 1.0, taus = AllTaus);    #Total Deviation
@btime mtie(arr, 1.0, taus = AllTaus);        #Maximum time interval error
println("Done")
```
Results:
```
37.702 ms (30 allocations: 436.13 KiB)  #Allan Deviation
39.805 ms (30 allocations: 371.13 KiB)  #Modified Allan Deviation
28.266 ms (30 allocations: 371.13 KiB)  #Hadamard Deviation
39.969 ms (51 allocations: 449.97 KiB)  #Time Deviation
150.508 ms (32 allocations: 865.89 KiB) #Total Deviation
240.852 ms (30 allocations: 631.44 KiB) #Maximum time interval error
Done

```

However, these timings need to be taken with a grain of salt, since it does not represent real world data.
