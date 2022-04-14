# PreludeDicts: fundamental APIs for dictionaries and sets

The primary function of PreludeDicts.jl is `modify!` which is a very flexible API (e.g., all
`Base` APIs can be implemented based on `modify!` efficiently) and also extensible (e.g.,
[lock-free dictionaries](https://github.com/JuliaConcurrent/ConcurrentCollections.jl) can
support this API).

PreludeDicts.jl also has functions `tryset!`, `trysetwith!` and `tryinsert!` using efficient
and debuggable error handling API [Try.jl](https://github.com/JuliaPreludes/Try.jl).
