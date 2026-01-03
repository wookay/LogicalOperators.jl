baremodule LogicalOperators

export ∧, ∨, ¬
export AbstractLogicalOperator, @logical_operator, @logicals

using Base: Base
using .Base: Vector, length, +, ==, <=
using .Base: Module, @__LINE__, push!, esc

abstract type AbstractLogicalOperator{T} end

macro logical_operator(Op::Symbol)
    esc(quote
        struct $Op{T} <: AbstractLogicalOperator{T}
            elements::Vector{T} where T

            function $Op{T}(elements::Vector{T}) where T
                new{T}(elements)
            end
            function $Op{T}(elements::T...) where T
                new{T}(Base.collect(T, elements))
            end
            function $Op()
                new{Any}([])
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

        function Base.length(op::$Op{T}) where T
            length(op.elements)
        end

        function Base.iterate(op::$Op{T}, i::Int=1) where T
            (1 <= i <= length(op.elements)) ? (op.elements[i], i + 1) : nothing
        end
    end) # esc(quote
end # macro logical_operator(Op)

function eval_logicals(mod::Module, syms::Tup) where Tup <: NTuple{N, Symbol} where N
    logical_macro = Symbol("@logical_operator")
    expr = Expr(:block)
    for op in syms
        macro_expr = Expr(:macrocall, logical_macro, @__LINE__, op)
        push!(expr.args, macro_expr)
    end
    Core.eval(mod, expr)
end # function logicals(syms::Tup) where Tup <: NTuple{N, Symbol} where N

macro logicals(ops::Symbol...)
    mod = __module__
    eval_logicals(mod, ops)
end # macro logicals(ops::Symbol...)

@logicals AND OR NOT


# ∧ \wedge   ∨ \vee   ¬ \neg

for (f, Op) in ((:wedge, :AND),
                (:vee,   :OR),
                (:neg,   :NOT))

    @Base.eval begin
        function ($f)(x::$Op{S1}, y::S2) where {S1, S2}
            T = Union{S1, S2}
            $Op{T}(Vector{T}(Base.vcat(x.elements, y)))
        end
        function ($f)()
            $Op()
        end
        function ($f)(elements...)
            Tup = typeof(elements)
            T = Union{Tup.parameters...}
            $Op{T}(Base.collect(T, elements))
        end

    end # @Base.eval begin
end # for (f, Op)

const ∧ = wedge
const ∨ = vee
const ¬ = neg

end # module LogicalOperators
