# PreludeDicts: fundamental APIs for dictionaries and sets

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapreludes.github.io/PreludeDicts.jl/dev)
[![CI](https://github.com/JuliaPreludes/PreludeDicts.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaPreludes/PreludeDicts.jl/actions/workflows/ci.yml)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

The primary function of PreludeDicts.jl is `modify!` which is a very flexible API (e.g., all
`Base` APIs can be implemented based on `modify!` efficiently) and also extensible (e.g.,
[lock-free dictionaries](https://github.com/JuliaConcurrent/ConcurrentCollections.jl) can
support this API).

PreludeDicts.jl also has functions `tryset!`, `trysetwith!` and `tryinsert!` using efficient
and debuggable error handling API [Try.jl](https://github.com/JuliaPreludes/Try.jl).

See the [Documentation](https://juliapreludes.github.io/PreludeDicts.jl/dev/) for API
reference.
