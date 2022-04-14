using Base: ht_keyindex2!, _setindex!, _delete!


function modify_unsafe!(f, h::Dict{K,V}, k0) where {K,V}
    key = convert(K, k0)
    index = ht_keyindex2!(h, key)

    if index > 0
        k1 = @inbounds h.keys[index]
        v1 = @inbounds h.vals[index]
        age0 = h.age
        reply = f(Pair{K,V}(k1, v1))
        reply isa Keep && return reply
    else
        age0 = h.age
        reply = f(nothing)
        reply isa Union{Keep,Delete,Nothing} && return reply
    end

    if h.age != age0
        index = ht_keyindex2!(h, key)
    end
    if reply isa Union{Delete,Nothing}
        _delete!(h, index)
    else
        v = something(reply)
        if index > 0
            h.age += 1
            @inbounds h.keys[index] = key
            @inbounds h.vals[index] = v
        else
            @inbounds _setindex!(h, v, key, -index)
        end
    end

    return reply
end
