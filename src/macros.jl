# baremodule LogicalOperators

using .Base: Vector, Module, @__LINE__
using .Base: esc, length, push!
using .Base: +, ==, <=

"""
    macro logical(Op::Symbol)
"""
macro logical(Op::Symbol)
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
end # macro logical(::Symbol)

function eval_logical_macro(mod::Module, syms::Tup) where Tup <: NTuple{N, Symbol} where N
    logical_macro = Symbol("@logical")
    expr = Expr(:block)
    for op in syms
        macro_expr = Expr(:macrocall, logical_macro, @__LINE__, op)
        push!(expr.args, macro_expr)
    end
    Core.eval(mod, expr)
end # function eval_logical_macro(::Module, ::Tup) where Tup <: NTuple{N, Symbol} where N

"""
    macro operators(ops::Symbol...)
"""
macro operators(ops::Symbol...)
    mod = __module__
    eval_logical_macro(mod, ops)
end # macro operators(::Symbol...)

# baremodule LogicalOperators
