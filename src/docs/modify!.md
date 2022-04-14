    modify!(f, dict, key) -> y

Modify the slot of `dict` for `key` using `f` that maps `nothing` or `key′ => value` to
`nothing`, `Some(value)`, [`Keep(_)`](@ref Keep), or [`Delete(_)`](@ref Delete).

`f` takes two types of argument:

* `nothing`: indicates that the slot associated with `key` is unoccupied.
* `key′ => value` (or a similar pair-like value): indicates that the slot associated with
  `key` stores `key′ => value`.

`f` can return the following values:

* `nothing` or `Delete(x)`: indicates that the value associated with `key` should be
  deleted. `Delete` is useful for returning a value computed in `f`.

* `Some(value)`: sets the new `value` for the slot associated with `key`.

* `Keep(x)`: indicates that the slot related to `key` should not be modified. It is useful
  for returning a value computed in `f`.

# Extended help

## Examples

```julia
julia> using PreludeDicts

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
