baremodule PreludeDicts

export Delete, Keep, TypedKeyError, modify!, tryget, tryinsert!, tryset!, trysetwith!

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
function tryget end
function tryinsert! end
function tryinsert_generic! end

# Like `Base.KeyError` but specialize for key to avoid allocations in `tryget`
struct TypedKeyError{Key} <: Exception
    key::Key
end

module Internal

using ExternalDocstrings: @define_docstrings
using Try: Try, Ok, Err
using ..PreludeDicts: PreludeDicts, Keep, Delete, TypedKeyError

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
