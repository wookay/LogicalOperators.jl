module test_logicaloperators_logic

using Test
using LogicalOperators

@test @logic(4 & 10) == 0

x = 3
@test @logic(x > 1 && x < 10 && x isa Int)
@test @logic(x > 1 && x < 10 && x isa String) === false
@test @logic(x > 1 && x isa String && x < 10) === false

@test @logic(x < 1 || x < 10 && x isa Int)
@test @logic(x < 1 || x > 10 && x isa Int) === false

end # module test_logicaloperators_logic
