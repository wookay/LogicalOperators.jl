module test_logicaloperators_boolean

using Test
using LogicalOperators # ∧ \wedge   ∨ \vee   ¬ \neg
using .LogicalOperators: AND, OR, NOT

Base.Bool(and::AND{Bool}) = all(identity, and.elements)
@test Bool(true ∧ true)
@test Bool(true ∧ true ∧ true)

Base.Bool(or::OR{Bool}) = any(identity, or.elements)
@test Bool(false ∨ false) === false
@test Bool(true ∨ false)
@test Bool(true ∨ false ∨ false)

import .LogicalOperators: NOT
NOT(and::AND{Bool}) = NOT(Bool(and))
NOT(or::OR{Bool}) = NOT(Bool(or))
Base.Bool(not::NOT{Bool}) = !(first(not.elements))
@test Bool(¬true) === false
@test Bool(NOT(true ∧ true)) === false
@test Bool(NOT(false ∨ false))

end # module test_logicaloperators_boolean
