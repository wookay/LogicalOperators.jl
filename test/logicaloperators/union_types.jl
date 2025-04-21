module test_logicaloperators_union_types

using Test
using LogicalOperators # ∧ \wedge   ∨ \vee   ¬ \neg
using .LogicalOperators: AND, OR, NOT

@test true ∧ true       == AND(true, true)      == AND{Bool}(true, true)
@test true ∧ 42         == AND(true, 42)        == AND{Union{Bool, Int}}(true, 42)
@test true ∧ 42 ∧ "abc" == AND(true, 42, "abc") == AND{Union{Bool, Int, String}}(true, 42, "abc")

@test true ∨ true       == OR(true, true)       == OR{Bool}(true, true)
@test true ∨ 42         == OR(true, 42)         == OR{Union{Bool, Int}}(true, 42)
@test true ∨ 42 ∨ "abc" == OR(true, 42, "abc")  == OR{Union{Bool, Int, String}}(true, 42, "abc")

@test ¬true == NOT{Bool}(true)
@test first(NOT{Union{Bool, Int}}(true).elements) isa Union{Bool, Int}

# julia/base/boot.jl
# const NTuple{N,T} = Tuple{Vararg{T,N}}
@test (NTuple{N,T} where {N, T}) === (Tuple{Vararg{T,N}} where {N, T})

end # module test_logicaloperators_union_types
