module test_logicaloperators_splatting

using Test
using LogicalOperators # ∧ \wedge   ∨ \vee
using .LogicalOperators: AND, OR

@test AND(AND(1, 2, 3)..., 5, 6, 7) == AND{Int}(1, 2, 3, 5, 6, 7)
@test OR(OR(1, 2, 3)..., 5, 6, 7)   == OR{Int}(1, 2, 3, 5, 6, 7)

@test AND((1 ∧ 2)..., 3) == 1 ∧ 2 ∧ 3
@test OR((1 ∨ 2)..., 3) == 1 ∨ 2 ∨ 3

end # module test_logicaloperators_splatting
