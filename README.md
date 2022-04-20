# PreludeDicts: fundamental APIs for dictionaries and sets

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapreludes.github.io/PreludeDicts.jl/dev)
[![CI](https://github.com/JuliaPreludes/PreludeDicts.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaPreludes/PreludeDicts.jl/actions/workflows/ci.yml)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

The primary function of PreludeDicts.jl is `modify!` which is a very flexible API (e.g., all
`Base` APIs can be implemented based on `modify!` efficiently) and also extensible (e.g.,
[lock-free dictionaries](https://github.com/JuliaConcurrent/ConcurrentCollections.jl) can
support this API).

PreludeDicts.jl also has functions `tryset!`, `trysetwith!`, `tryget` and `tryinsert!` using
efficient and debuggable error handling API
[Try.jl](https://github.com/JuliaPreludes/Try.jl).

See the [Documentation](https://juliapreludes.github.io/PreludeDicts.jl/dev/) for API
reference.

## Tutorial

### `modify!`

`modify!(f, dict. key)` provides a very powerful API for accessing and manipulating the
value associated with a key.  It takes a single-argument function `f` that takes

* `nothing` if `key` does not exist
* a key-value pair if `key` has a value

as an argument and then can return

* `nothing` to delete the value
* `Some(value)` to insert the `value`

The function `f` can also return, as an optimization:

* `Delete(data)` to delete the value but also propagating `data` to the caller
* `Keep(data)` to not change the value but propagating `data` to the caller

For example, `modify!` can be used to insert or set a value

```julia
julia> using PreludeDicts

julia> dict = Dict(:a => 0);

julia> modify!(Returns(Some(111)), dict, :a)
Some(111)

julia> dict[:a]
111
```

or delete a value

```julia
julia> dict = Dict(:a => 0);

julia> modify!(Returns(nothing), dict, :a)

julia> haskey(dict, :a)
false
```

or access the value

```julia
julia> dict = Dict(:a => 111);

julia> getvalue(x) = x === nothing ? nothing : Some(last(x));

julia> modify!(getvalue, dict, :a)
Some(111)

julia> modify!(getvalue, dict, :b) === nothing
true
```

`modify!` is powerful because above operations can be dynamically controlled using the
function `f`:

```julia
julia> inc!(dict, key) = modify!(dict, key) do slot
           if slot === nothing
               Some(1)
           else
               Some(last(slot) + 1)
           end
       end;

julia> dict = Dict(:a => 111);

julia> inc!(dict, :a)
Some(112)

julia> inc!(dict, :b)
Some(1)

julia> dict == Dict(:a => 112, :b => 1)
true
```

If `modify!` is directly implemented (which is the case for `Dict` for some Julia versions),
it is more efficient than, e.g., `dict[key] = get(dict, key, 0) + 1` which requires two hash
function calls and probings.

#### `Keep` and `Delete`

Note that `modify!(getvalue, dict, :a)` above is not maximally efficient since it re-inserts
the existing value.  As a (rather micro) optimization, `Keep` can be used instead

```julia
julia> dict = Dict(:a => 111);

julia> getvalue2(x) = x === nothing ? nothing : Keep(last(x));

julia> y = modify!(getvalue2, dict, :a)
Keep(111)

julia> y[]  # get the wrapped data
111

julia> modify!(getvalue2, dict, :b) === nothing
true
```

To help implementing functions like `pop!` efficiently, `modify` also supports `Delete` that
signals the deletion like `nothing` but can have a data payload.

```julia
julia> y = modify!(Delete, dict, :a)
Delete(:a => 111)

julia> y[]  # get the wrapped data
:a => 111

julia> haskey(dict, :a)
false
```

### `trysetwith!`

`trysetwith!(f, dict, key)` is like `get!(f, dict, key)` but the returned value esncode
if the value returned by `f` is inserted or not.

```julia
julia> dict = Dict(:a => 111);

julia> trysetwith!(Returns(222), dict, :a)
Try.Err: :a => 111

julia> trysetwith!(Returns(222), dict, :b)
Try.Ok: :b => 222

julia> dict == Dict(:a => 111, :b => 222)
true
```

### `tryset!`

`tryset!(dict, key, value)` is like `get!(dict, key, value)` but the returned value encodes
if the `value` is inserted or not.

```julia
julia> dict = Dict(:a => 111);

julia> tryset!(dict, :a, 222)
Try.Err: :a => 111

julia> tryset!(dict, :b, 222)
Try.Ok: :b => 222

julia> dict == Dict(:a => 111, :b => 222)
true
```

### `tryget`

`tryget(dict, key)` is similar to `dict[key]` but the returned value encodes if the `key`
exists or not, instead of throwing.

```julia
julia> dict = Dict(:a => 111);

julia> tryget(dict, :a)
Try.Ok: 111

julia> tryget(dict, :b)
Try.Err: TypedKeyError: key :b not found
```

### `tryinsert!`

`tryinsert!(set, x)` is like `push!(set, x)` but the the returned value encodes if the item
`x` is inserted or not.

```julia
julia> set = Set([111]);

julia> tryinsert!(set, 111)
Try.Err: 111

julia> tryinsert!(set, 222)
Try.Ok: 222

julia> set == Set([111, 222])
true
```

## Discussion

### Benchmarks

`modify!`-based implementations show 40% to 50% performance improvements in some benchmarks:

```JULIA
julia> using PreludeDictsBenchmarks

julia> suite = PreludeDictsBenchmarks.setup();

julia> results = run(suite)
2-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "TrySet" => 2-element BenchmarkTools.BenchmarkGroup:
          tags: []
          "impl=:tryset!" => Trial(27.639 μs)
          "impl=:tryset_generic!" => Trial(39.650 μs)
  "Increments" => 2-element BenchmarkTools.BenchmarkGroup:
          tags: []
          "impl=:modify!" => Trial(1.001 ms)
          "impl=:modify_generic!" => Trial(1.587 ms)
```

where the implementations (`impl`) with `_generic!` suffix uses the generic implementation
that is not written in terms of the direct implementation of `modify!` that touches the
dictionary internals.

See [`benchmark/PreludeDictsBenchmarks`](benchmark/PreludeDictsBenchmarks) for benchmark
code.

### Deriving `AbstractDict` API using `modify!`

Various efficient `AbstractDict` API implementations can be derived from `modify!`, showing
that this is a powerful API basis:

```julia
julia> function getindex′(dict, key)
           y = modify!(Keep, dict, key)
           y === nothing && throw(KeyError(key))
           return last(y[])
       end;

julia> getindex′(Dict(:a => 111), :a)
111

julia> setindex′!(dict, value, key) = modify!(Returns(Some(value)), dict, key);

julia> dict = Dict();

julia> setindex′!(dict, 111, :a);

julia> dict[:a]
111

julia> function pop′!(dict, key)
           pair = modify!(Delete, dict, key)[]
           pair === nothing && throw(KeyError(key))
           return last(pair)
       end;

julia> pop′!(dict, :a)
111

julia> dict == Dict()
true

julia> function get′!(f, dict, key)
           y = modify!(dict, key) do pair
               if pair === nothing
                   Some(f())
               else
                   Keep(last(pair))
               end
           end
           return y isa Keep ? y[] : something(y)
       end;

julia> get′!(() -> 222, dict, :a)
222

julia> dict[:a]
222

julia> get′!(() -> 333, dict, :a)
222

julia> dict[:a]
222
```

### Comparison to token-based API

Other dictionary interfaces have been explored.
[Dictionaries.jl](https://github.com/andyferris/Dictionaries.jl) has a token-based API to
avoid repeatedly calling hash function and probings.  Other languages have similar
mechanism. For example, Rust's `HashMap` has the [`Entry`
API](https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html) that achieves the
same effect.  However, since Julia has coroutine (`Task`), the token system is "isomorphic"
to `modify!` in the sense that one can be implemented in terms of another (see below).

More importantly, `modify!` gives more freedom to *the dictionary implementer* in how the
function `f` passed by the user is called.  For example, in lock-free dictionaries, it may
be possible that `f` is called multiple times if multiple tasks try to update the same slot
concurrently.  Indeed,
[ConcurrentCollections](https://github.com/JuliaConcurrent/ConcurrentCollections.jl) uses a
similar API to manipulate `ConcurrentDict`.  (TODO: Use PreludeDicts.jl in
ConcurrentCollections.jl.)

#### Token API in terms of `modify!` using a coroutine

```julia
struct Token  # not specializing for fields for simplicity
    task::Task
    key::Any
    state::Union{Nothing,Pair}
end

function gettoken(dict, key)
    parent = current_task()
    task = @task begin
        y = modify!(dict, key) do state
            yieldto(parent, state)
        end
        yieldto(parent, y)
    end
    return Token(task, key, yieldto(task))
end

function Base.getindex(token::Token)
    state = token.state
    state === nothing && throw(KeyError(token.key))
    return last(state)
end

Base.setindex!(token::Token, value) = yieldto(token.task, Some(value))

dict = Dict()

tk = gettoken(dict, :a)
tk[] = 111

tk = gettoken(dict, :a)
tk[]
# output
111
```
