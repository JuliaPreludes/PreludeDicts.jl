    trysetwith!(factory, dict, key) -> Ok(key′ => value′) or Err(key′ => dict[key′])

Set `dict[key] = factory()` if `dict[key]` does not exist and return `Ok(key′ => value′)`
where the `key′ => value′` is the key-value pair just inserted at `dict[key]`. Return
`Err(key′ => dict[key])` if `dict[key]` exists.

# Extended help

## Examples

```julia
julia> using PreludeDicts

julia> dict = Dict(:a => 111);

julia> trysetwith!(Returns(222), dict, :a)
Try.Err: :a => 111

julia> trysetwith!(Returns(222), dict, :b)
Try.Ok: :b => 222

julia> dict == Dict(:a => 111, :b => 222)
true
```
