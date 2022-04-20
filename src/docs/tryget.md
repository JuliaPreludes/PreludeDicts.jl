    tryget(dict, key) -> Ok(value) or Err(TypedKeyError(key))

Look up the `key` and return the `value` wrapped in an `Ok` if found.  Return
`Err(TypedKeyError(key))` otherwise.

# Extended help

## Examples

```julia
julia> using PreludeDicts

julia> dict = Dict(:a => 111);

julia> tryget(dict, :a)
Try.Ok: 111

julia> tryget(dict, :b)
Try.Err: TypedKeyError: key :b not found
```
