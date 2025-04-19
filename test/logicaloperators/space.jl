module test_logicaloperators_space

using Test
using LogicalOperators: AbstractLogicalOperator

for Op in (:SPACE, :COMMA)
    @Base.eval begin
        struct $Op{T} <: AbstractLogicalOperator{T}
            elements::Vector{T} where T

            function $Op{T}(elements::Vector{T}) where T
                new{T}(elements)
            end
            function $Op{T}(elements::T...) where T
                new{T}(Base.collect(T, elements))
            end
            function $Op(elements...)
                Tup = typeof(elements)
                T = Union{Tup.parameters...}
                new{T}(Base.collect(T, elements))
            end
        end

        function Base.:(==)(s1::$Op{T}, s2::$Op{T})::Bool where T
            s1.elements == s2.elements
        end

        function Base.iterate(op::$Op{T}, i::Int=1) where T
            (1 <= i <= length(op.elements)) ? (op.elements[i], i + 1) : nothing
        end
    end # @Base.eval begin
end # for Op

Base.show(io::IO, space::SPACE{String}) = join(io, space.elements, " ")
Base.show(io::IO, comma::COMMA{<:Union{Int, String}}) = join(io, comma.elements, ", ")

@test SPACE("hello", "world") == SPACE{String}("hello", "world")
@test COMMA(1, 2, 3) == COMMA{Int}(1, 2, 3)

@test sprint(show, SPACE("hello", "world")) == "hello world"
@test sprint(show, COMMA(1, 2, 3)) == "1, 2, 3"

@test COMMA(COMMA(1, 2, 3)..., 5, 6, 7) == COMMA{Int}(1, 2, 3, 5, 6, 7)

end # module test_logicaloperators_space
