```@docs
LogicalOperators.@logic
```

### `@logic`

To help understanding the bitwise (`&`, `|`), short-circuiting booleans (`&&`, `||`).

```julia-repl
julia> using LogicalOperators

julia> @logic 4 & 10
   0b0100  4
 & 0b1010 10
   0b0000  0
0

julia> @logic 4 | 10
   0b0100  4
 | 0b1010 10
   0b1110 14
14

julia> @logic 4 | 10 | 1
   0b0100  4
 | 0b1010 10
   0b1110 14
 | 0b0001  1
   0b1111 15
15
```

```julia-repl
julia> using LogicalOperators

julia> x = 3;

julia> @logic x > 1
x > 1
true

julia> @logic x < 1 || x > 10 && x isa Int
x < 1 || x > 10 && x isa Int
false
```
