module test_logic_flow

using Test
using LogicalOperators

include("settings.jl")

x = 3
@test @logic(x & 10)       ==    2

x = 5
@test @logic(x & 10)       ==    0

x = 9
@test @logic(x & 10)       ==    8

end # module test_logic_flow
