# Total deviation

## Formula
total variance

$$Tot\,\sigma_y^2(\tau)=\frac{1}{2\tau^2(N-2)}\sum_{j=2}^{N-1}\left(x_{j-m}^*-2x_{j}^*+x_{j+m}^*\right)^2$$

## Doc String

```@docs
totaldev(x)
```
## Possible issues
 * `totaldev` can be called with a non-overlapping calculation. This throws a warning because it is unusual to use but nevertheless faster.
