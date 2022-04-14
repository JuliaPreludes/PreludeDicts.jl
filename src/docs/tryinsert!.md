    tryinsert!(set, x) -> Ok(x′) or Err(x′′)

Insert `x` if it does not exist in `set` and return `Ok(x′)` where `x′` is the value just
inserted to `set`. Otherwise, return `Err(x′′)` where `x′′` is the value exists in `set`
that is equivalent to `x`.

`x === x′` or `x === x′′` may not hold if `x isa eltype(set)` does not hold.

# Extended help

## Examples

```julia
julia> using PreludeDicts

julia> set = Set([111]);

julia> tryinsert!(set, 111)
Try.Err: 111

julia> tryinsert!(set, 222)
Try.Ok: 222

julia> set == Set([111, 222])
true
```
