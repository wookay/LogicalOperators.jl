# LogicalOperators 🧩

| **Documentation**                       | **Build Status**                |
|:---------------------------------------:|:-------------------------------:|
| [![][docs-latest-img]][docs-latest-url] | [![][actions-img]][actions-url] |

```julia-repl
julia> using LogicalOperators: AND, OR, XOR, NOT, ∧, ∨, ⊕, ¬

julia> AND(1, 2) == 1 ∧ 2
true

julia> OR{Int}(1, 2, 3) == 1 ∨ 2 ∨ 3
true

julia> XOR("🧩", "🧩") == "🧩" ⊕ "🧩"
true

julia> NOT(true) == ¬true
true
```


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/LogicalOperators.jl/

[actions-img]: https://github.com/wookay/LogicalOperators.jl/actions/workflows/actions.yml/badge.svg
[actions-url]: https://github.com/wookay/LogicalOperators.jl/actions
