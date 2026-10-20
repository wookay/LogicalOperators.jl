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


w = 0x0f0f0f0f_0f0f0f0f::UInt64

# from julia/base/parsers/floats.jl
# @inline function ishexdigits8(w::UInt64)
#     x = w | 0x20202020_20202020
#     digit = (w + 0x50505050_50505050) & ~(w + 0x46464646_46464646)
#     letter = (x + 0x1f1f1f1f_1f1f1f1f) & ~(x + 0x19191919_19191919)
#     return (w & 0x80808080_80808080 == 0) &
#            ((digit | letter) & 0x80808080_80808080 == 0x80808080_80808080)
# end
x = w | 0x20202020_20202020
@test @logic( w | 0x20202020_20202020 ) == 0x2f2f2f2f2f2f2f2f
digit = (w + 0x50505050_50505050) & ~(w + 0x46464646_46464646)
@test @logic( (w + 0x50505050_50505050) & ~(w + 0x46464646_46464646) ) == 0x0a0a0a0a0a0a0a0a
letter = (x + 0x1f1f1f1f_1f1f1f1f) & ~(x + 0x19191919_19191919)
@test @logic( (x + 0x1f1f1f1f_1f1f1f1f) & ~(x + 0x19191919_19191919) ) == 0x0606060606060606
@test @logic( (w & 0x80808080_80808080 == 0) &
              ((digit | letter) & 0x80808080_80808080 == 0x80808080_80808080) ) == false

# from julia/base/parsers/ints.jl
# @inline function hexdigits8(w::UInt64)
#     w = (w & 0x0f0f0f0f_0f0f0f0f) + ((w >> 6) & 0x01010101_01010101) * 9
#     w = ((w << 4) | (w >> 8)) & 0x00ff00ff_00ff00ff
#     w = ((w << 8) | (w >> 16)) & 0x0000ffff_0000ffff
#     return ((w << 16) | (w >> 32)) & 0x00000000_ffffffff
@test @logic( (w & 0x0f0f0f0f_0f0f0f0f) + ((w >> 6) & 0x01010101_01010101) * 9 ) == 0x0f0f0f0f0f0f0f0f
@test @logic( ((w << 4) | (w >> 8)) & 0x00ff00ff_00ff00ff                      ) == 0x00ff00ff00ff00ff
@test @logic( ((w << 8) | (w >> 16)) & 0x0000ffff_0000ffff                     ) == 0x00000f0f00000f0f
@test @logic( ((w << 16) | (w >> 32)) & 0x00000000_ffffffff                    ) == 0x000000000f0f0f0f

end # module test_logic_bitwise
