module TestDoctest

using PreludeDicts
using Documenter

function test()
    VERSION < v"1.7" && return
    doctest(PreludeDicts; manual = false)
end

end  # module
