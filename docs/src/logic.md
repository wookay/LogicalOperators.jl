```@docs
LogicalOperators.@logic
```

### `@logic`

To help understanding the bitwise (`&`, `|`), short-circuiting booleans (`&&`, `||`).

```julia-repl
julia> using LogicalOperators

julia> @logic 4 & 10
   0b00100  4
 & 0b01010 10
   0b00000  0
0

julia> @logic 4 | 10
   0b00100  4
 | 0b01010 10
   0b01110 14
14

julia> @logic 4 | 10 | 1
   0b00100  4
 | 0b01010 10
   0b01110 14
 | 0b00001  1
   0b01111 15
15
```

* [Hexagrams 卦](https://github.com/wookay/Hexagrams.jl/blob/main/test/hexagrams/logic.jl) example.
```julia-repl
julia> using LogicalOperators

julia> using Hexagrams.八卦

julia> @logic ⊻(乾, 坤)
   0b111 乾
 ⊻ 0b000 坤
   0b111 乾
卦(0x07)
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
