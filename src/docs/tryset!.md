    tryset!(dict, key, value) -> Ok(key′ => value′) or Err(key′ => dict[key′])

Set `dict[key] = value` if `dict[key]` does not exist and return `Ok(key′ => value′)` where
the `key′ => value′` is the key-value pair just inserted at `dict[key]`. Return
`Err(key′ => dict[key])` if `dict[key]` exists.

`value === value′` and/or `key === key′` may not hold if `value isa valtype(dict)` does not
hold.

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
