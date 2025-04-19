module test_logicaloperators_logical

using Test
using LogicalOperators
using .LogicalOperators: AND, OR, NOT

warn_msg = if VERSION >= v"1.13.0-DEV.9"
    "WARNING: Imported binding LogicalOperators.^ was undeclared at import time during import to test_logicaloperators_logical.\n"
else
    "WARNING: could not import LogicalOperators.^ into test_logicaloperators_logical"
end
@test_warn warn_msg @eval(using .LogicalOperators: ^) # U+005E

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
