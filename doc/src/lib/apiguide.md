# API guide

Every deviation function uses the same input and output structure.

```Julia
(tau, deviation, error, count) = XXXdev(data, rate; frequency = false, overlapping = true, taus = 192)
```

## Input Parameter
```Julia
data, rate; frequency = false, overlapping = true, taus = 192
```
 * `data` - is the data to calculate the deviation from. It must be either phase data (default) or frequency data according to the `frequency` argument. The type of the array can be any possible numeric type and the deviations function are type stable.
 * `rate` - is the rate as a Float, which describes the data capturing rate of your dataset.


 * `[frequency]` *optional*, *named* - can be set to false (default) if the `data` argument contains phase data or `true` if the `data` argument contains frequency data.
 * `[overlapping]` *optional*, *named* - can be set to true (default) for the overlapping deviation or false for the consecutive one.
 * `[taus]` *optional*, *named* - describes at which averaging time the deviation should be calculated. This can be either:
   - An `AllanTauDescriptor` type where there is: `AllTaus`, `QuarterOctave`, `HalfOctave`, `Octave`, `HalfDecade`, `Decade` and produces respective log-spaced points
   - A Float Array which describes at which taus the deviation should be evaluated
   - A Float which produces an according base-log-spaced array of taus
   - An Integer (default, 192) which produces an array of equally many log-spaced taus. (Note: this does not mean, that exactly this count of deviations will be returned because some can be discarded due to too few contributing terms)

## Output Tuple
Every deviation returns a named output tuple:
```Julia
(tau, deviation, error, count)
```
 * `tau` - the taus where the respective deviations got calculated on
 * `deviation` - the deviations
 * `error` - the respective deviation errors
 * `count` - the respective count of contributing terms for each deviation (always 2 <= count < N)
