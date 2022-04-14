module BenchTrySet

using BenchmarkTools
using PreludeDicts

function benchmark(tryset!; nkeys = 1000)
    dict = Dict{Int,Int}()
    sizehint!(dict, 4 * nkeys)
    function go()
        for k in 1:nkeys
            tryset!(dict, k, 0)
        end
    end
end

function setup()
    suite = BenchmarkGroup()
    for f in [tryset!, PreludeDicts.tryset_generic!]
        suite["impl=:$(nameof(f))"] = @benchmarkable go() setup = (go = benchmark($f))
    end
    return suite
end

function clear() end

end  # module
