# LogicalOperators 🧩

| **Documentation**                       | **Build Status**                |
|:---------------------------------------:|:-------------------------------:|
| [![][docs-latest-img]][docs-latest-url] | [![][actions-img]][actions-url] |

This is a Julia package that handles general logical operators.

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
![short-circuiting_booleans.png](https://raw.github.com/wookay/LogicalOperators.jl/main/docs/images/short-circuiting_booleans.png)


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


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/LogicalOperators.jl/

[actions-img]: https://github.com/wookay/LogicalOperators.jl/actions/workflows/actions.yml/badge.svg
[actions-url]: https://github.com/wookay/LogicalOperators.jl/actions
