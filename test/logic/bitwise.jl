module test_logic_bitwise

using Test
using LogicalOperators

@test @logic(4)            ==    4
@test @logic(4 & 10)       ==    0
@test @logic(4 | 10)       ==   14
@test @logic(4 | 10 | 1)   ==   15
@test @logic(4 | 10 & 1)   ==    4
@test @logic(4 | (10 | 1)) ==   15
@test @logic(1024 | 128)   == 1152

end # module test_logic_bitwise
