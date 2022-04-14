if VERSION > v"1.9-"
    # https://github.com/JuliaLang/julia/pull/44513
    include("unsafe_impls_jl19.jl")
else
    include("unsafe_impls_jl18.jl")
end

function trysetwith_unsafe!(f::F, dict::AbstractDict{K,V}, key) where {F,K,V}
    key = convert(K, key)
    reply = modify_unsafe!(dict, key) do pair
        if pair === nothing
            # Not using `Some{V}(f())` since `f` may be inferrable while `V` may be
            # non-concrete.
            Some(f())
        else
            Keep(pair)
        end
    end
    if reply isa Some
        return Ok(Pair{K,V}(key, something(reply)))
    else
        return Err(reply.value)
    end
end

tryset_unsafe!(dict, key, value) = trysetwith_unsafe!(Returns(value), dict, key)

returns_nothing() = nothing

function tryinsert_unsafe!(set::Set{T}, x0) where {T}
    dict = set.dict::Dict{T,Nothing}
    result = trysetwith_unsafe!(returns_nothing, dict, x0)
    if Try.isok(result)
        return Ok{T}(first(Try.unwrap(result)))
    else
        return Err{T}(first(Try.unwrap_err(result)))
    end
end
