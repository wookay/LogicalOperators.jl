```@docs
LogicalOperators.@logic
```

### `@logic`

To help understanding the bitwise (`&`, `|`), short-circuiting booleans (`&&`, `||`).

```julia-repl
julia> using LogicalOperators

julia> @logic 4 & 10
  00000100
& 00001010
----------
  00000000
0

julia> @logic 4 | 10
  00000100
| 00001010
----------
  00001110
14
```

```julia-repl
julia> x = 3;

julia> @logic x > 1 && x < 10 && x isa Int
x > 1 && x < 10 && x isa Int
true

julia> @logic x < 1 || x > 10 && x isa Int
x < 1 || x > 10 && x isa Int
false
```
