module test_logicaloperators_logical

using Test
using LogicalOperators
using .LogicalOperators: AND, OR, NOT

@test ∧(1, 2) == AND(1, 2)
@test ∨(1, 2) == OR(1, 2)

@test ∧(1, 2) == ∧(2)(1) == 1 ∧ 2
@test ∨(1, 2) == ∨(2)(1) == 1 ∨ 2

@test ∧(1, 2, 3) == 1 ∧ 2 ∧ 3
@test ∨(1, 2, 3) == 1 ∨ 2 ∨ 3

@test ¬1 == NOT(1)

end # module test_logicaloperators_logical
