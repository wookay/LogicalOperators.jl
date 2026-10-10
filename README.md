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
