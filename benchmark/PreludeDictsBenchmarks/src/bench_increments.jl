module BenchIncrements

using BenchmarkTools
using PreludeDicts

function benchmark(modify!; nkeys = 1000, ntries = 100)
    dict = Dict{Int,Int}(1:nkeys .=> 0)
    function go()
        for _ in 1:ntries
            for k in 1:nkeys
                modify!(dict, k) do pair
                    if pair === nothing
                        0
                    else
                        last(pair) + 1
                    end
                end
            end
        end
    end
end

function setup()
    suite = BenchmarkGroup()
    for f in [modify!, PreludeDicts.modify_generic!]
        suite["impl=:$(nameof(f))"] = @benchmarkable go() setup = (go = benchmark($f))
    end
    return suite
end

function clear() end

end  # module
