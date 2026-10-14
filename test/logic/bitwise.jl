module test_logic_bitwise

using Test
using LogicalOperators

include("settings.jl")

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

# from julia/base/parsers/ints.jl
# @inline function hexdigits8(w::UInt64)
#     w = (w & 0x0f0f0f0f_0f0f0f0f) + ((w >> 6) & 0x01010101_01010101) * 9
#     w = ((w << 4) | (w >> 8)) & 0x00ff00ff_00ff00ff
#     w = ((w << 8) | (w >> 16)) & 0x0000ffff_0000ffff
#     return ((w << 16) | (w >> 32)) & 0x00000000_ffffffff
w = 0x0f0f0f0f_0f0f0f0f::UInt64
@test @logic( (w & 0x0f0f0f0f_0f0f0f0f) + ((w >> 6) & 0x01010101_01010101) * 9 ) == 0x0f0f0f0f0f0f0f0f
@test @logic( ((w << 4) | (w >> 8)) & 0x00ff00ff_00ff00ff                      ) == 0x00ff00ff00ff00ff
@test @logic( ((w << 8) | (w >> 16)) & 0x0000ffff_0000ffff                     ) == 0x00000f0f00000f0f
@test @logic( ((w << 16) | (w >> 32)) & 0x00000000_ffffffff                    ) == 0x000000000f0f0f0f

end # module test_logic_bitwise
