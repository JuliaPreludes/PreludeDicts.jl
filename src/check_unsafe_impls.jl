const Try = Base.require(Base.PkgId(Base.UUID(0xbf1d0ff0c4a9496b85f02b0d71c4f32a), "Try"))
using .Try

if !@isdefined(Returns)
    const Compat =
        Base.require(Base.PkgId(Base.UUID(0x34da2185b29b5c13b0c7acf172513d20), "Compat"))
    using .Compat: Returns
end

struct Keep{Value}
    value::Value
end

struct Delete{Value}
    value::Value
end

include("unsafe_impls.jl")

for dict in [Dict(), Dict{Symbol,Int}(), Dict{Union{Symbol,Int},Int}()]
    @assert Try.unwrap(tryset_unsafe!(dict, :k1, 111)) == (:k1 => 111)
    @assert Try.unwrap_err(tryset_unsafe!(dict, :k1, 222)) == (:k1 => 111)
end

for set in [Set(), Set{Int}()]
    @assert Try.unwrap(tryinsert_unsafe!(set, 111)) == 111
    @assert Try.unwrap_err(tryinsert_unsafe!(set, 111)) == 111
end
