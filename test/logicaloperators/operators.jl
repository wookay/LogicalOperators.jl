module test_logicaloperators_operators

using Test
using LogicalOperators: AND, OR, XOR, NOT, ∧, ∨, ⊕, ¬

@test ∧() == AND() == AND{Any}()
@test ∨() == OR()  == OR{Any}()
@test ⊕() == XOR() == XOR{Any}()
@test ¬() == NOT() == NOT{Any}()

@test AND(1) == AND{Int}(1) == ∧(1)
@test OR(1)  == OR{Int}(1)  == ∨(1)
@test XOR(1) == XOR{Int}(1) == ⊕(1)
@test NOT(1) == NOT{Int}(1) == ¬1

@test AND(1, 2) == AND{Int}(1, 2) == ∧(1, 2) == 1 ∧ 2
@test OR(1, 2)  == OR{Int}(1, 2)  == ∨(1, 2) == 1 ∨ 2
@test XOR(1, 2) == XOR{Int}(1, 2) == ⊕(1, 2) == 1 ⊕ 2

@test AND(1, 2, 3) == AND{Int}(1, 2, 3) == ∧(1, 2, 3) == 1 ∧ 2 ∧ 3
@test OR(1, 2, 3)  == OR{Int}(1, 2, 3)  == ∨(1, 2, 3) == 1 ∨ 2 ∨ 3
@test XOR(1, 2, 3) == XOR{Int}(1, 2, 3) == ⊕(1, 2, 3) == 1 ⊕ 2 ⊕ 3

@test_throws MethodError AND{Int}("a", "b", "c")
@test_throws MethodError AND{String}(1, 2)

end # module test_logicaloperators_operators
