    tryset!(dict, key, new_value) -> Ok(new_value′) or Err(existing_value)

Set `dict[key] = new_value` if `dict[key]` does not exist and return `Ok(new_value′)` where
the `new_value′` is the value just inserted at `dict[key]`. Return `Err(dict[key])` if
`dict[key]` exists.

`new_value === new_value′` may not hold if `new_value isa valtype(dict)` does not hold.

# Extended help

## Examples

```julia
julia> using PreludeDicts

julia> dict = Dict(:a => 111);

julia> tryset!(dict, :a, 222)
Try.Err: :a => 111

julia> tryset!(dict, :b, 222)
Try.Ok: :b => 222

julia> dict == Dict(:a => 111, :b => 222)
true
```
