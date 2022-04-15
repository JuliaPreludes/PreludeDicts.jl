baremodule PreludeDicts

export Delete, Keep, modify!, tryinsert!, tryset!, trysetwith!

struct Keep{Value}
    value::Value
end

struct Delete{Value}
    value::Value
end

function modify! end
function modify_generic! end

function trysetwith! end
function trysetwith_generic! end
function tryset! end
function tryset_generic! end
function tryinsert! end
function tryinsert_generic! end

module Internal

using ExternalDocstrings: @define_docstrings
using Try: Try, Ok, Err
using ..PreludeDicts: PreludeDicts, Keep, Delete

const Result = Union{Ok,Err}

if !@isdefined(Returns)
    using Compat: Returns
end

include("utils.jl")
include("generic.jl")
include("show.jl")

include("unsafe_impls.jl")
include("maybe_use_unsafe.jl")

end  # module Internal

Internal.@define_docstrings

end  # baremodule PreludeDicts
