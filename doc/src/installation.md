# Installation guide

AllanDeviations.jl is registered in [Metadata.jl](https://github.com/JuliaLang/METADATA.jl/tree/metadata-v2/AllanDeviations).
Therefore it is part of the official, public package system.

You can download and install it in your global Julia installation (or local project)
via opening a Julia Console/REPL and type:

```Julia
using Pkg
Pkg.add("AllanDeviations")
```
This installs all necessary files. **This only needs to be done once!**

Afterwards, the package can be loaded by

```Julia
using AllanDeviations
```

## Updating

The package installation can be updated to the newest version with:

```Julia
using Pkg
Pkg.update("AllanDeviations")
```

Or even by updating all installed packages

```Julia
using Pkg
Pkg.update()
```
