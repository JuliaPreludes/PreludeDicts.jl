    trysetwith!(factory, dict, key) -> Ok(new_value) or Err(existing_value)

Set `dict[key] = factory()` if `dict[key]` does not exist and return `Ok(new_value)` where
the `new_value` is the value just inserted at `dict[key]`. Return `Err(dict[key])` if
`dict[key]` exists.

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
