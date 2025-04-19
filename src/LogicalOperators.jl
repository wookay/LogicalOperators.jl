baremodule LogicalOperators

export ∧, ∨, ¬

using Base: Base, Vector
using .Base: length, +, ==, <=

abstract type AbstractLogicalOperator{T} end

for (f, Op) in ((:wedge, :AND),
                (:vee,   :OR))
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

        ($f)(x::T) where T = Base.Fix2($Op{T}, x)
        function ($f)(x::$Op{S1}, y::S2) where {S1, S2}
            T = Union{S1, S2}
            $Op{T}(Vector{T}(Base.vcat(x.elements, y)))
        end
        function ($f)(elements...)
            Tup = typeof(elements)
            T = Union{Tup.parameters...}
            $Op{T}(Base.collect(T, elements))
        end

    end # @Base.eval begin
end # for (f, Op)

struct NOT{T} <: AbstractLogicalOperator{T}
    x::T

    NOT{T}(x::T) where {T} = new{T}(x)
    NOT(x::T) where {T} = new{T}(x)
end

neg(x::T) where T = NOT{T}(x)

const ∧ = wedge
const ∨ = vee
const ¬ = neg

end # module LogicalOperators
