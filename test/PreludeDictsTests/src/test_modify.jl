module TestModify

using PreludeDicts
using PreludeDicts.Internal: Returns
using Test

returns_nothing(_) = nothing

function check_get(modify!)
    dict = Dict(:a => 111)
    @test modify!(Some ∘ last, dict, :a) === Some(111)
    @test dict == Dict(:a => 111)

    dict = Dict(:a => 111)
    @test modify!(Keep, dict, :a) === Keep(:a => 111)
    @test dict == Dict(:a => 111)

    dict = Dict(:a => 111)
    @test modify!(x -> Keep(x), dict, :a) === Keep(:a => 111)
    @test dict == Dict(:a => 111)

    dict = Dict(:a => 111)
    @test modify!(identity, dict, :b) === nothing
    @test dict == Dict(:a => 111)

    dict = Dict(:a => 111)
    @test modify!(returns_nothing, dict, :b) === nothing
    @test dict == Dict(:a => 111)
end

test_default_get() = check_get(modify!)
test_generic_get() = check_get(PreludeDicts.modify_generic!)

function check_set(modify!)
    dict = Dict{Symbol,Int}()
    @test modify!(_ -> Some(111), dict, :a) === Some(111)
    @test dict[:a] == 111
end

test_default_set() = check_set(modify!)
test_generic_set() = check_set(PreludeDicts.modify_generic!)

function check_delete(modify!)
    dict = Dict(:a => 111)
    @test modify!(_ -> nothing, dict, :a) === nothing
    @test !haskey(dict, :a)

    dict = Dict(:a => 111)
    @test modify!(x -> Delete(x), dict, :a) === Delete(:a => 111)
    @test !haskey(dict, :a)

    dict = Dict(:a => 111)
    @test modify!(Delete, dict, :a) === Delete(:a => 111)
    @test !haskey(dict, :a)

    dict = Dict(:a => 111)
    @test modify!(_ -> Delete(222), dict, :a) === Delete(222)
    @test !haskey(dict, :a)

    dict = Dict(:a => 111)
    @test modify!(Returns(Delete(222)), dict, :a) === Delete(222)
    @test !haskey(dict, :a)
end

test_default_delete() = check_delete(modify!)
test_generic_delete() = check_delete(PreludeDicts.modify_generic!)

function check_inc(modify!)
    dict = Dict(:a => 111)
    @test modify!(pair -> Some(last(pair) + 111), dict, :a) === Some(222)
    @test dict == Dict(:a => 222)
end

test_default_inc() = check_inc(modify!)
test_generic_inc() = check_inc(PreludeDicts.modify_generic!)

end  # module
