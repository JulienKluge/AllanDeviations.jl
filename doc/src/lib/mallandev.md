# Modified Allan deviation

## Formula
Modified Allan variance

$$Mod\,\sigma_y^2(\tau)=\frac{1}{2m^2\tau^2(N-3m+1)}\sum_{j=1}^{N-3m+1}\left(\sum_{t=j}^{j+m-1}[x_{t+2m}-2x_{t+m}+x_{t}]\right)^2$$

## Doc String

```@docs
mallandev(x)
```
