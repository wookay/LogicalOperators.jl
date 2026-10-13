module test_logic_short_circuiting_booleans

using Test
using LogicalOperators

include("settings.jl")

@test @logic(false) === false
@test @logic(false && true) === false
@test @logic( false &&  false  || true )
@test @logic((false &&  false) || true )
@test @logic( false && (false  || true)) === false ### wrong output
@test @logic((1 > 2) && (3 > 4) || (6 > 5))

x = 3
@test @logic(x > 1)
@test @logic(x < 1) === false
@test @logic(x > 1 && x < 10)
@test @logic(x > 1 && x < 10 && x isa Int)
@test @logic(x > 1 && x < 10 && x isa String) === false
@test @logic(x > 1 && x isa String && x < 10) === false
@test @logic(x < 1 || x < 10 && x isa Int)
@test @logic(x < 1 || x > 10 && x isa Int) === false

end # module test_logic_short_circuiting_booleans
