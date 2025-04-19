module test_logicaloperators_logical

using Test
using LogicalOperators # ∧ ∨ ¬
using .LogicalOperators: AND, OR, NOT

@test ∧(1, 2) == AND(1, 2) == AND{Int}(1, 2)
@test ∨(1, 2) == OR(1, 2) == OR{Int}(1, 2)
@test AND(1, 2) isa AND{Int}
@test OR(1, 2) isa OR{Int}

@test ∧(1, 2) == ∧(2)(1) == 1 ∧ 2
@test ∨(1, 2) == ∨(2)(1) == 1 ∨ 2

@test ∧(1, 2, 3) == 1 ∧ 2 ∧ 3 == AND(1, 2, 3) == AND{Int}(1, 2, 3)
@test ∨(1, 2, 3) == 1 ∨ 2 ∨ 3 == OR(1, 2, 3) == OR{Int}(1, 2, 3)

@test ¬1 == NOT(1) == NOT{Int}(1)
@test NOT(1) isa NOT{Int}

end # module test_logicaloperators_logical
