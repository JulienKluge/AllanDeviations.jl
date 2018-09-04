# AllanDeviations.jl

AllanDeviations.jl is a package for the [Julia programming language](https://www.julialang.org).

It provides fast frequency and phase stability deviations/variances for different purposes and timescales
in a unified API ([API guide](@ref)) and plain Julia without any dependencies.

It was build and tested against Julia v1 and should be therefore upwards compatible for a long time.

## Implemented Deviations/Functions

#### [Allan deviation](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* General purpose choice

#### [Modified Allan deviation](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* Used to distinguish W and F PM

#### [Hadamard deviation](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* Rejects frequency drift, and handles divergent noise

#### [Time deviation](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* General time error of time source

#### [Total deviation](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* Better confidence at long averages for Allan

#### [Maximum time interval error](@ref)
* Overlapping & non-overlapping
* Frequency- & phase data
* Measure of clock error commonly used in the tele-communications industry


## Example Calculation

This is an example plot of some AllanDeviations.jl calculations of a Potassium-D2-Frequency beat note from two reference lasers.
![Potassium D2](assets/DeviationResults.png)

## References
The main algorithms where implemented with the help of a C Reference implementations from [leapsecond.com](http://www.leapsecond.com/tools/adev_lib.c) and the main Literature from [NIST - Riley, William J. "Handbook of frequency stability analysis." (2008): 81.](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication1065.pdf).
The Python package [allantools](https://pypi.org/project/AllanTools/) was used as reference test implementation to verify the results against.
