module test_logic_bitwise

using Test
using LogicalOperators

@test @logic(3 & 10)       ==    2
@test @logic(10 | 7)       ==   15
@test @logic(3 &  10 | 7)  ==    7
@test @logic(3 & (10 | 7)) ==    3
@test @logic(1024 | 128)   == 1152

@test @logic(1 << 5)       ==   32
@test @logic(1 << 5 >> 2)  ==    8

@test @logic(0b1)          ==  0b1
@test @logic(0x2)          ==  0x2
@test @logic(3)            ==    3

end # module test_logic_bitwise
