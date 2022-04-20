PreludeDicts.modify!(f, dict, key) = PreludeDicts.modify_generic!(f, dict, key)

struct _NotSet end
const NOTSET = _NotSet()

function PreludeDicts.modify_generic!(f, dict, key)
    key = convert(keytype(dict), key)
    value = get(dict, key, NOTSET)
    reply = if value === NOTSET
        f(nothing)
    else
        f(Pair{keytype(dict),valtype(dict)}(key, value))
    end
    if reply isa Keep
        # do nothing
    elseif reply isa Union{Delete,Nothing}
        if value !== NOTSET
            delete!(dict, key)
        end
    else
        dict[key] = something(reply)
    end
    return reply
end

function PreludeDicts.modify_generic!(f::Returns, dict, key)
    reply = f()
    if reply isa Keep
        # do nothing
    elseif reply isa Union{Delete,Nothing}
        delete!(dict, key)
    else
        dict[key] = something(reply)
    end
    return reply
end

Base.getindex(x::Keep) = x.value
Base.getindex(x::Delete) = x.value

struct RecordIfCalled{F} <: Function
    f::F
    iscalled::typeof(Ref(false))
end

RecordIfCalled(f::F) where {F} = RecordIfCalled(f, Ref(false))
RecordIfCalled(::Type{T}) where {T} = RecordIfCalled{Type{T}}(T, Ref(false))

@inline function (f::RecordIfCalled)()
    f.iscalled[] = true
    f.f()
end

PreludeDicts.trysetwith!(factory::F, dict, key) where {F} =
    PreludeDicts.trysetwith_generic!(factory, dict, key)

function PreludeDicts.trysetwith_generic!(
    factory::F,
    dict::AbstractDict{K,V},
    key,
)::Result where {F,K,V}
    f = RecordIfCalled(factory)
    key = convert(K, key)
    x = @inlinecall get!(f, dict, key)
    p = Pair{K,V}(key, x)
    return f.iscalled[] ? Ok(p) : Err(p)
end

PreludeDicts.tryset!(dict, key, value) = PreludeDicts.trysetwith!(Returns(value), dict, key)
PreludeDicts.tryset_generic!(dict, key, value) =
    PreludeDicts.trysetwith_generic!(Returns(value), dict, key)

function PreludeDicts.tryget(dict, key)
    value = get(dict, key, NOTSET)
    if value === NOTSET
        return Err(TypedKeyError(key))
    else
        return Ok{valtype(dict)}(value)
    end
end

PreludeDicts.tryinsert!(set, x) = PreludeDicts.tryinsert_generic!(set, x)
function PreludeDicts.tryinsert_generic!(set::AbstractSet{T}, x)::Result where {T}
    x = convert(eltype(set), x)
    if x ∈ set
        return Err{T}(x)
    else
        push!(set, x)
        return Ok{T}(x)
    end
end
