module test_logicaloperators_show

using Test
using LogicalOperators
using .LogicalOperators: AND, OR, NOT

Base.show(io::IO, and::AND{<:Union{Bool, Int}}) = join(io, and.elements, " ∧ ")
@test sprint(show, true ∧ false) == "true ∧ false"
@test sprint(show, 1 ∧ 2) == "1 ∧ 2"

Base.show(io::IO, or::OR{<:Union{Bool, Int}}) = join(io, or.elements, " ∨ ")
@test sprint(show, true ∨ false) == "true ∨ false"
@test sprint(show, 1 ∨ 2) == "1 ∨ 2"

Base.show(io::IO, not::NOT{<:Union{Bool, Int}}) = print(io, "¬", not.x)
@test sprint(show, ¬true) == "¬true"

end # module test_logicaloperators_show
