```@docs
LogicalOperators.@logic
```

### `@logic`

To help understanding the bitwise (`&`, `|`), short-circuiting booleans (`&&`, `||`).

```julia-repl
julia> using LogicalOperators

julia> @logic 3 & 10
   0b0011  3
 & 0b1010 10
   0b0010  2
2

julia> @logic 10 | 7
   0b1010 10
 | 0b0111  7
   0b1111 15
15

julia> @logic 3 & 10 | 7
   0b0011  3
 & 0b1010 10
   0b0010  2
 | 0b0111  7
   0b0111  7
7

julia> @logic 3 & (10 | 7)
   0b1010 10
 | 0b0111  7
   0b1111 15
   0b0011  3
 & 0b1111 15
   0b0011  3
3
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
