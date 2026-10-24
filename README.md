# LogicalOperators 🧩

| **Documentation**                       | **Build Status**                |
|:---------------------------------------:|:-------------------------------:|
| [![][docs-latest-img]][docs-latest-url] | [![][actions-img]][actions-url] |

This is a Julia package that handles general logical operators.

### `@logic`

To help understanding the bitwise (`&`, `|`), short-circuiting booleans (`&&`, `||`).

```julia-repl
julia> using LogicalOperators

julia> @logic 3 & 10
   0b0011    3
 & 0b1010   10
   0b0010    2
2

julia> @logic 10 | 7
   0b1010   10
 | 0b0111    7
   0b1111   15
15

julia> @logic 3 & 10 | 7
   0b0011    3
 & 0b1010   10
   0b0010    2
 | 0b0111    7
   0b0111    7
7

julia> @logic 3 & (10 | 7)
   0b1010   10
 | 0b0111    7
   0b1111   15
   0b0011    3
 & 0b1111   15
   0b0011    3
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
