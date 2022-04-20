module TestTry

using PreludeDicts
using Test
using Try

mutable struct Object{T}
    value::T
end

Base.:(==)(a::Object{T}, b::Object{T}) where {T} = isequal(a.value, b.value)
Base.hash(a::Object) = hash(a.value, 0xc7061595f484142f)

function check_tryset_simple(tryset!)
    dict = Dict()
    p1 = Pair{Any,Any}(:k1, 111)
    @test tryset!(dict, :k1, 111) === Ok(p1)
    @test tryset!(dict, :k1, 222) == Err(p1)
end

test_tryset_simple() = check_tryset_simple(tryset!)
test_tryset_generic_simple() = check_tryset_simple(PreludeDicts.tryset_generic!)

function test_tryset_object()
    @assert PreludeDicts.Internal.USE_UNSAFE

    dict = Dict{Object{Int},Int}()
    k1 = Object(111)
    k2 = Object(111)
    @test tryset!(dict, k1, 111) === Ok(k1 => 111)
    @test tryset!(dict, k2, 222) == Err(k1 => 111)
end

function test_tryget()
    dict = Dict(:a => 111)
    @test tryget(dict, :a) === Ok(111)
    @test tryget(dict, :b) === Err(TypedKeyError(:b))
end

function test_typedkeyerror()
    @test endswith(sprint(show, TypedKeyError(:b)), "TypedKeyError(:b)")
    @test endswith(sprint(show, TypedKeyError{Any}(:b)), "TypedKeyError{Any}(:b)")
    @test sprint(showerror, TypedKeyError(:b)) == "TypedKeyError: key :b not found"
end

function check_tryinsert_simple(tryinsert!)
    set = Set()
    @test tryinsert!(set, 111) === Ok{Any}(111)
    @test tryinsert!(set, 111) == Err{Any}(111)
end

test_tryinsert_simple() = check_tryinsert_simple(tryinsert!)
test_tryinsert_generic_simple() = check_tryinsert_simple(PreludeDicts.tryinsert_generic!)

function test_tryinsert_object()
    @assert PreludeDicts.Internal.USE_UNSAFE

    a = Object(111)
    b = Object(111)
    set = Set{typeof(a)}()
    @test a == b
    @test hash(a) == hash(b)
    @test tryinsert!(set, a) === Ok(a)
    @test tryinsert!(set, b) === Err(a)
end

end  # module
