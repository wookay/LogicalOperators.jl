module test_logic_bitwise

using Test
using LogicalOperators

@test @logic(4)          ==    4
println()
@test @logic(4 & 10)     ==    0
println()
@test @logic(4 | 10)     ==   14
println()
@test @logic(4 | 10 | 1) ==   15
println()
@test @logic(1024 | 128) == 1152

end # module test_logic_bitwise
