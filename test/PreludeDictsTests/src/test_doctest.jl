module TestDoctest

using PreludeDicts
using Documenter

test() = doctest(PreludeDicts; manual = false)

end  # module
