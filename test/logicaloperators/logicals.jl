module test_logicaloperators_logicals

using Test
using LogicalOperators # @logicals

@logicals SPACE COMMA
@test SPACE("hello", "world") == SPACE{String}("hello", "world")
@test COMMA(1, 2, 3) == COMMA{Int}(1, 2, 3)
@test COMMA(COMMA(1, 2, 3)..., 5, 6, 7) == COMMA{Int}(1, 2, 3, 5, 6, 7)

Base.show(io::IO, space::SPACE{String}) = join(io, space.elements, " ")
Base.show(io::IO, comma::COMMA{<:Union{Int, String}}) = join(io, comma.elements, ", ")
@test sprint(show, SPACE("hello", "world")) == "hello world"
@test sprint(show, COMMA(1, 2, 3)) == "1, 2, 3"

@logicals LF
@test LF("hello", "world") == LF{String}("hello", "world")

Base.show(io::IO, space::LF{String}) = join(io, space.elements, "\n")
@test sprint(show, LF("hello", "world")) == "hello\nworld"

end # module test_logicaloperators_logicals
