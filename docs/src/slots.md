### Slots

Data structures similar to a `Vector`.

```julia-repl
julia> using LogicalOperators: AND, OR, XOR, NOT, ∧, ∨, ⊕, ¬

julia> AND(1, 2) == 1 ∧ 2
true

julia> OR{Int}(1, 2, 3) == 1 ∨ 2 ∨ 3
true

julia> NOT(true) == ¬true
true
```


| LaTeX short name             | unicode | operator      |
|:---------------------------- |:------- |:------------- |
| `\wedge`                     | ∧       | [`AND`](@ref) |
| `\vee`                       | ∨       | [`OR`](@ref)  |
| `\oplus`                     | ⊕       | [`XOR`](@ref) |
| `\neg`                       | ¬       | [`NOT`](@ref) |

```@docs
LogicalOperators.AND
LogicalOperators.OR
LogicalOperators.XOR
LogicalOperators.NOT
```

```@docs
LogicalOperators.AbstractSlot
LogicalOperators.@add_slot
```
