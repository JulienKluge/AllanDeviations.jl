# Maximum time interval error

## Formula
Maximum time interval error

$$Mtie(\tau)=\operatorname{max}_{1\leq k\leq N-n}\left(\operatorname{max}_{k\leq t\leq k+n}(x_t)-\operatorname{min}_{k\leq t\leq k+n}(x_t)\right)$$

## Doc String

```@docs
mtie(x)
```

## Possible issues
 * `mtie` in itself needs a great amount of computations and can be very slow for big taus with many data points. When computations need too much time, consider reducing the number of taus and/or especially using smaller taus.
 * Mtie can be called with a non-overlapping calculation. This throws a warning because it is unusual to use but nevertheless faster.
