var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#AllanDeviations.jl-1",
    "page": "Home",
    "title": "AllanDeviations.jl",
    "category": "section",
    "text": "AllanDeviations.jl is a package for the Julia programming language.It provides fast frequency and phase stability deviations/variances for different purposes and timescales in a unified API (API guide) and plain Julia without any dependencies.It was build and tested against Julia v1 and should be therefore upwards compatible for a long time."
},

{
    "location": "index.html#Implemented-Deviations/Functions-1",
    "page": "Home",
    "title": "Implemented Deviations/Functions",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#[Allan-deviation](@ref)-1",
    "page": "Home",
    "title": "Allan deviation",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nGeneral purpose choice"
},

{
    "location": "index.html#[Modified-Allan-deviation](@ref)-1",
    "page": "Home",
    "title": "Modified Allan deviation",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nUsed to distinguish W and F PM"
},

{
    "location": "index.html#[Hadamard-deviation](@ref)-1",
    "page": "Home",
    "title": "Hadamard deviation",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nRejects frequency drift, and handles divergent noise"
},

{
    "location": "index.html#[Time-deviation](@ref)-1",
    "page": "Home",
    "title": "Time deviation",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nGeneral time error of time source"
},

{
    "location": "index.html#[Total-deviation](@ref)-1",
    "page": "Home",
    "title": "Total deviation",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nBetter confidence at long averages for Allan"
},

{
    "location": "index.html#[Maximum-time-interval-error](@ref)-1",
    "page": "Home",
    "title": "Maximum time interval error",
    "category": "section",
    "text": "Overlapping & non-overlapping\nFrequency- & phase data\nMeasure of clock error commonly used in the tele-communications industry"
},

{
    "location": "index.html#Example-Calculation-1",
    "page": "Home",
    "title": "Example Calculation",
    "category": "section",
    "text": "This is an example plot of some AllanDeviations.jl calculations of a Potassium-D2-Frequency beat note from two reference lasers. (Image: Potassium D2)"
},

{
    "location": "index.html#References-1",
    "page": "Home",
    "title": "References",
    "category": "section",
    "text": "The main algorithms where implemented with the help of a C Reference implementations from leapsecond.com and the main Literature from NIST - Riley, William J. \"Handbook of frequency stability analysis.\" (2008): 81.. The Python package allantools was used as reference test implementation to verify the results against."
},

{
    "location": "installation.html#",
    "page": "Installation Guide",
    "title": "Installation Guide",
    "category": "page",
    "text": ""
},

{
    "location": "installation.html#Installation-guide-1",
    "page": "Installation Guide",
    "title": "Installation guide",
    "category": "section",
    "text": "AllanDeviations.jl is registered in Metadata.jl. Therefore it is part of the official, public package system.You can download and install it in your global Julia installation (or local project) via opening a Julia Console/REPL and type:using Pkg\nPkg.add(\"AllanDeviations\")This installs all necessary files. This only needs to be done once!Afterwards, the package can be loaded byusing AllanDeviations"
},

{
    "location": "installation.html#Updating-1",
    "page": "Installation Guide",
    "title": "Updating",
    "category": "section",
    "text": "The package installation can be updated to the newest version with:using Pkg\nPkg.update(\"AllanDeviations\")Or even by updating all installed packagesusing Pkg\nPkg.update()"
},

{
    "location": "quickstart.html#",
    "page": "Quick Start Guide",
    "title": "Quick Start Guide",
    "category": "page",
    "text": ""
},

{
    "location": "quickstart.html#Quickstart-1",
    "page": "Quick Start Guide",
    "title": "Quickstart",
    "category": "section",
    "text": ""
},

{
    "location": "quickstart.html#Installation-1",
    "page": "Quick Start Guide",
    "title": "Installation",
    "category": "section",
    "text": "Install the package once in a Julia Console/REPL with:using Pkg\nPkg.add(\"AllanDeviations\")"
},

{
    "location": "quickstart.html#Loading-1",
    "page": "Quick Start Guide",
    "title": "Loading",
    "category": "section",
    "text": "The package can be loaded in every Julia program with a simple using directiveusing AllanDeviations"
},

{
    "location": "quickstart.html#Allan-Deviation-of-random-data-1",
    "page": "Quick Start Guide",
    "title": "Allan Deviation of random data",
    "category": "section",
    "text": "Print the overlapping Allan Deviation of one million random points with rate 1.0 at octave log-spaced taus:using AllanDeviations\n\narr = rand(Float64, 1_000_000)\n\nresult = allandev(arr, 1.0)\n\nprintln(result.deviation)"
},

{
    "location": "quickstart.html#Other-deviations-1",
    "page": "Quick Start Guide",
    "title": "Other deviations",
    "category": "section",
    "text": "result = allandev(arr, 1.0)    #Allan deviation\nresult = mallandev(arr, 1.0)   #Modified Allan deviation\nresult = hadamarddev(arr, 1.0) #Hadamard deviation\nresult = timedev(arr, 1.0)     #Time deviation\nresult = totaldev(arr, 1.0)    #Total deviation\nresult = mtie(arr, 1.0)        #Maximum time interval error"
},

{
    "location": "quickstart.html#Full-Data-result-1",
    "page": "Quick Start Guide",
    "title": "Full Data result",
    "category": "section",
    "text": "Every deviation method returns a named tuple in the form (tau, deviation, error, count)println(\"Calculated taus:\")\nprintln(result.tau)\n\nprintln(\"Calculated Deviations:\")\nprintln(result.deviation)\n\nprintln(\"Calculated errors:\")\nprintln(result.error)\n\nprintln(\"Calculated Term Number:\")\nprintln(result.count)"
},

{
    "location": "quickstart.html#Same-Result-via-tuple-deconstruction-1",
    "page": "Quick Start Guide",
    "title": "Same Result via tuple deconstruction",
    "category": "section",
    "text": "The returned tuple can already be deconstructed into variables on return.(myTaus, myDeviation, myError, myCount) = allandev(arr, 1.0)"
},

{
    "location": "quickstart.html#Calculating-on-frequency-data-1",
    "page": "Quick Start Guide",
    "title": "Calculating on frequency data",
    "category": "section",
    "text": "AllanDeviations.jl assumes by default that the data-argument contains phase data. This can be changed by setting the optional named argument frequency to true for frequency data.result = allandev(arr, 1.0, frequency = true)"
},

{
    "location": "quickstart.html#Non-Overlapping-1",
    "page": "Quick Start Guide",
    "title": "Non-Overlapping",
    "category": "section",
    "text": "AllanDeviations.jl will by default calculate the overlapping deviations. This can be changed by setting the optional named argument overlapping to false.result = allandev(arr, 1.0, overlapping = false)"
},

{
    "location": "quickstart.html#Addressing-different-taus-1",
    "page": "Quick Start Guide",
    "title": "Addressing different taus",
    "category": "section",
    "text": "#Key-Types\nallandev(arr, 1.0, taus = AllTaus)       #all possible taus\nallandev(arr, 1.0, taus = QuarterOctave) #quarter octave log-spaced\nallandev(arr, 1.0, taus = HalfOctave)    #half octave log-spaced\nallandev(arr, 1.0, taus = Octave)        #octave log-spaced\nallandev(arr, 1.0, taus = HalfDecade)    #hald decade log-spaced\nallandev(arr, 1.0, taus = Decade)        #decade log-spaced\n\n#Explicit taus\nallandev(arr, 1.0, taus = [2.0])           #calculate deviation at tau=2.0 if possible\nallandev(arr, 1.0, taus = [2.0, 3.0, 4.0]) #calculate deviation at tau=2.0, tau=3.0 & tau=4.0 if possible\n\n#Custom log scale\nallandev(arr, 1.0, taus = 1.2) #calculate 1/5 of an octave log-spaced\n\n#Custom log count\nallandev(arr, 1.0, taus = 100) #calculate 100 log-spaced tau values between min and maximal possible tau\n#This does not guarantee that 100 deviations will be calculated since some values will be discarded\n#when less than two terms contributed to it"
},

{
    "location": "quickstart.html#Benchmark-Deviations-1",
    "page": "Quick Start Guide",
    "title": "Benchmark Deviations",
    "category": "section",
    "text": ""
},

{
    "location": "quickstart.html#Benchmark-different-overlapping-deviations-for-one-million-datapoints-and-200-taus-1",
    "page": "Quick Start Guide",
    "title": "Benchmark different overlapping deviations for one million datapoints and 200 taus",
    "category": "section",
    "text": "using BenchmarkTools\narr = rand(Float64, 1_000_000);\n@btime allandev(arr, 1.0, taus = 200);    #Allan Deviation\n@btime mallandev(arr, 1.0, taus = 200);   #Modified Allan Deviation\n@btime hadamarddev(arr, 1.0, taus = 200); #Hadamard Deviation\n@btime timedev(arr, 1.0, taus = 200);     #Time Deviation\n@btime totaldev(arr, 1.0, taus = 200);    #Total Deviation\n@btime mtie(arr, 1.0, taus = 200);        #Maximum time interval error\nprintln(\"Done\")Results315.247 ms (52 allocations: 35.91 KiB) #Allan Deviation\n309.990 ms (52 allocations: 35.28 KiB) #Modified Allan Deviation\n278.230 ms (52 allocations: 35.28 KiB) #Hadamard Deviation\n309.647 ms (57 allocations: 39.33 KiB) #Time Deviation\n331.483 ms (54 allocations: 22.92 MiB) #Total Deviation\n901.942 ms (52 allocations: 35.91 KiB) #Maximum time interval error\nDoneFor comparison, pythons allantools needs approximately 3.5 seconds for the Allan deviation, 6.5 seconds for the total deviation and an indeterminate amount of time for mtie (to be fair, allantools also provides a fastmtie which seems to be currently unfinished though)."
},

{
    "location": "quickstart.html#Benchmark-different-overlapping-deviations-for-10.000-data-points-and-all-possible-taus:-1",
    "page": "Quick Start Guide",
    "title": "Benchmark different overlapping deviations for 10.000 data points and all possible taus:",
    "category": "section",
    "text": "using BenchmarkTools\narr = rand(Float64, 10_000)\n@btime allandev(arr, 1.0, taus = AllTaus);    #Allan Deviation\n@btime mallandev(arr, 1.0, taus = AllTaus);   #Modified Allan Deviation\n@btime hadamarddev(arr, 1.0, taus = AllTaus); #Hadamard Deviation\n@btime timedev(arr, 1.0, taus = AllTaus);     #Time Deviation\n@btime totaldev(arr, 1.0, taus = AllTaus);    #Total Deviation\n@btime mtie(arr, 1.0, taus = AllTaus);        #Maximum time interval error\nprintln(\"Done\")Results:37.702 ms (30 allocations: 436.13 KiB)  #Allan Deviation\n39.805 ms (30 allocations: 371.13 KiB)  #Modified Allan Deviation\n28.266 ms (30 allocations: 371.13 KiB)  #Hadamard Deviation\n39.969 ms (51 allocations: 449.97 KiB)  #Time Deviation\n150.508 ms (32 allocations: 865.89 KiB) #Total Deviation\n240.852 ms (30 allocations: 631.44 KiB) #Maximum time interval error\nDone\nHowever, these timings need to be taken with a grain of salt, since it does not represent real world data."
},

{
    "location": "lib/apiguide.html#",
    "page": "API guide",
    "title": "API guide",
    "category": "page",
    "text": ""
},

{
    "location": "lib/apiguide.html#API-guide-1",
    "page": "API guide",
    "title": "API guide",
    "category": "section",
    "text": "Every deviation function uses the same input and output structure.(tau, deviation, error, count) = XXXdev(data, rate; frequency = false, overlapping = true, taus = 192)"
},

{
    "location": "lib/apiguide.html#Input-Parameter-1",
    "page": "API guide",
    "title": "Input Parameter",
    "category": "section",
    "text": "data, rate; frequency = false, overlapping = true, taus = 192data - is the data to calculate the deviation from. It must be either phase data (default) or frequency data according to the frequency argument. The type of the array can be any possible numeric type and the deviations function are type stable.\nrate - is the rate as a Float, which describes the data capturing rate of your dataset.[frequency] optional, named - can be set to false (default) if the data argument contains phase data or true if the data argument contains frequency data.\n[overlapping] optional, named - can be set to true (default) for the overlapping deviation or false for the consecutive one.\n[taus] optional, named - describes at which averaging time the deviation should be calculated. This can be either:\nAn AllanTauDescriptor type where there is: AllTaus, QuarterOctave, HalfOctave, Octave, HalfDecade, Decade and produces respective log-spaced points\nA Float Array which describes at which taus the deviation should be evaluated\nA Float which produces an according base-log-spaced array of taus\nAn Integer (default, 192) which produces an array of equally many log-spaced taus. (Note: this does not mean, that exactly this count of deviations will be returned because some can be discarded due to too few contributing terms)"
},

{
    "location": "lib/apiguide.html#Output-Tuple-1",
    "page": "API guide",
    "title": "Output Tuple",
    "category": "section",
    "text": "Every deviation returns a named output tuple:(tau, deviation, error, count)tau - the taus where the respective deviations got calculated on\ndeviation - the deviations\nerror - the respective deviation errors\ncount - the respective count of contributing terms for each deviation (always 2 <= count < N)"
},

{
    "location": "lib/allandev.html#",
    "page": "Allan Deviation",
    "title": "Allan Deviation",
    "category": "page",
    "text": ""
},

{
    "location": "lib/allandev.html#Allan-deviation-1",
    "page": "Allan Deviation",
    "title": "Allan deviation",
    "category": "section",
    "text": ""
},

{
    "location": "lib/allandev.html#Formula-1",
    "page": "Allan Deviation",
    "title": "Formula",
    "category": "section",
    "text": "Allan variancesigma_y^2(tau)=frac12(N-2m)tau^2sum_j=1^N-2m(x_j+2m-2x_j+m+x_j)^2"
},

{
    "location": "lib/allandev.html#AllanDeviations.allandev-Tuple{Any}",
    "page": "Allan Deviation",
    "title": "AllanDeviations.allandev",
    "category": "method",
    "text": "allandev(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the allan deviation\n\n#parameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:		True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\n#returns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/allandev.html#Doc-String-1",
    "page": "Allan Deviation",
    "title": "Doc String",
    "category": "section",
    "text": "allandev(x)"
},

{
    "location": "lib/mallandev.html#",
    "page": "Modified Allan Deviation",
    "title": "Modified Allan Deviation",
    "category": "page",
    "text": ""
},

{
    "location": "lib/mallandev.html#Modified-Allan-deviation-1",
    "page": "Modified Allan Deviation",
    "title": "Modified Allan deviation",
    "category": "section",
    "text": ""
},

{
    "location": "lib/mallandev.html#Formula-1",
    "page": "Modified Allan Deviation",
    "title": "Formula",
    "category": "section",
    "text": "Modified Allan varianceModsigma_y^2(tau)=frac12m^2tau^2(N-3m+1)sum_j=1^N-3m+1left(sum_t=j^j+m-1x_t+2m-2x_t+m+x_tright)^2"
},

{
    "location": "lib/mallandev.html#AllanDeviations.mallandev-Tuple{Any}",
    "page": "Modified Allan Deviation",
    "title": "AllanDeviations.mallandev",
    "category": "method",
    "text": "mallandev(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the modified allan deviation\n\n#parameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:		True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\n#returns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/mallandev.html#Doc-String-1",
    "page": "Modified Allan Deviation",
    "title": "Doc String",
    "category": "section",
    "text": "mallandev(x)"
},

{
    "location": "lib/hadamarddev.html#",
    "page": "Hadamard Deviation",
    "title": "Hadamard Deviation",
    "category": "page",
    "text": ""
},

{
    "location": "lib/hadamarddev.html#Hadamard-deviation-1",
    "page": "Hadamard Deviation",
    "title": "Hadamard deviation",
    "category": "section",
    "text": ""
},

{
    "location": "lib/hadamarddev.html#Formula-1",
    "page": "Hadamard Deviation",
    "title": "Formula",
    "category": "section",
    "text": "Hadamard varianceHsigma_y^2(tau)=frac16tau^2(N-3m)sum_j=1^N-3mleft(x_j+3-3x_j+2+3x_j+1-x_jright)^2"
},

{
    "location": "lib/hadamarddev.html#AllanDeviations.hadamarddev-Tuple{Any}",
    "page": "Hadamard Deviation",
    "title": "AllanDeviations.hadamarddev",
    "category": "method",
    "text": "hadamarddev(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the hadamard deviation\n\n#parameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:		True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\n#returns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/hadamarddev.html#Doc-String-1",
    "page": "Hadamard Deviation",
    "title": "Doc String",
    "category": "section",
    "text": "hadamarddev(x)"
},

{
    "location": "lib/timedev.html#",
    "page": "Time Deviation",
    "title": "Time Deviation",
    "category": "page",
    "text": ""
},

{
    "location": "lib/timedev.html#Time-deviation-1",
    "page": "Time Deviation",
    "title": "Time deviation",
    "category": "section",
    "text": ""
},

{
    "location": "lib/timedev.html#Formula-1",
    "page": "Time Deviation",
    "title": "Formula",
    "category": "section",
    "text": "time variancesigma_x^2(tau)=fractau^23Modsigma_y^2(tau)"
},

{
    "location": "lib/timedev.html#AllanDeviations.timedev-Tuple{Any}",
    "page": "Time Deviation",
    "title": "AllanDeviations.timedev",
    "category": "method",
    "text": "timedev(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the time deviation\n\n#parameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:		True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\n#returns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/timedev.html#Doc-String-1",
    "page": "Time Deviation",
    "title": "Doc String",
    "category": "section",
    "text": "timedev(x)"
},

{
    "location": "lib/totaldev.html#",
    "page": "Total Deviation",
    "title": "Total Deviation",
    "category": "page",
    "text": ""
},

{
    "location": "lib/totaldev.html#Total-deviation-1",
    "page": "Total Deviation",
    "title": "Total deviation",
    "category": "section",
    "text": ""
},

{
    "location": "lib/totaldev.html#Formula-1",
    "page": "Total Deviation",
    "title": "Formula",
    "category": "section",
    "text": "total varianceTotsigma_y^2(tau)=frac12tau^2(N-2)sum_j=2^N-1left(x_j-m^*-2x_j^*+x_j+m^*right)^2"
},

{
    "location": "lib/totaldev.html#AllanDeviations.totaldev-Tuple{Any}",
    "page": "Total Deviation",
    "title": "AllanDeviations.totaldev",
    "category": "method",
    "text": "totaldev(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the total deviation\n\n#parameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:		True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\n#returns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/totaldev.html#Doc-String-1",
    "page": "Total Deviation",
    "title": "Doc String",
    "category": "section",
    "text": "totaldev(x)"
},

{
    "location": "lib/totaldev.html#Possible-issues-1",
    "page": "Total Deviation",
    "title": "Possible issues",
    "category": "section",
    "text": "totaldev can be called with a non-overlapping calculation. This throws a warning because it is unusual to use but nevertheless faster."
},

{
    "location": "lib/mtie.html#",
    "page": "Max. time interval error",
    "title": "Max. time interval error",
    "category": "page",
    "text": ""
},

{
    "location": "lib/mtie.html#Maximum-time-interval-error-1",
    "page": "Max. time interval error",
    "title": "Maximum time interval error",
    "category": "section",
    "text": ""
},

{
    "location": "lib/mtie.html#Formula-1",
    "page": "Max. time interval error",
    "title": "Formula",
    "category": "section",
    "text": "Maximum time interval errorMtie(tau)=operatornamemax_1leq kleq N-nleft(operatornamemax_kleq tleq k+n(x_t)-operatornamemin_kleq tleq k+n(x_t)right)"
},

{
    "location": "lib/mtie.html#AllanDeviations.mtie-Tuple{Any}",
    "page": "Max. time interval error",
    "title": "AllanDeviations.mtie",
    "category": "method",
    "text": "mtie(data, rate; [frequency=false], [overlapping=true], [taus=Octave]) Calculates the maximal time interval error\n\nparameters:\n\n<data>:			The data array to calculate the deviation from either as as phases or frequencies.\n<rate>:			The rate of the data given.\n[frequency]:	True if data contains frequency data otherwise (default) phase data is assumed.\n[overlapping]:	True (default) to calculate overlapping deviation, false otherwise.\n[taus]:			Taus to calculate the deviation at. This can either be an AllanTauDescriptor type AllTaus, Decadade, HalfDecade, Octave, HalfOctave, QuarterOctave, an array of taus to calculate at, a float number to build a custom log-scale on or an integer to build a specific number of log spaced points.\n\nreturns: named tupple (tau, deviation, error, count)\n\ntau:		Taus which where used.\ndeviation:	Deviations calculated.\nerror:		Respective errors.\ncount:		Number of contributing terms for each deviation.\n\n\n\n\n\n"
},

{
    "location": "lib/mtie.html#Doc-String-1",
    "page": "Max. time interval error",
    "title": "Doc String",
    "category": "section",
    "text": "mtie(x)"
},

{
    "location": "lib/mtie.html#Possible-issues-1",
    "page": "Max. time interval error",
    "title": "Possible issues",
    "category": "section",
    "text": "mtie in itself needs a great amount of computations and can be very slow for big taus with many data points. When computations need too much time, consider reducing the number of taus and/or especially using smaller taus.\nMtie can be called with a non-overlapping calculation. This throws a warning because it is unusual to use but nevertheless faster."
},

]}
