# baremodule LogicalOperators

# AND  ∧  \wedge
# OR   ∨  \vee
# XOR  ⊕  \oplus
# NOT  ¬  \neg

using .Base: Vector, Module, @__LINE__
using .Base: esc, length, push!
using .Base: +, ==, <=

"""
    abstract type AbstractSlot{T} end
"""
abstract type AbstractSlot{T} end

"""
    macro add_slot(Op::Symbol)
"""
macro add_slot(Op::Symbol)
    esc(quote
        struct $Op{T} <: AbstractSlot{T}
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
end # macro add_slot(Op::Symbol)

function eval_add_slot(mod::Module, syms::Tup) where Tup <: NTuple{N, Symbol} where N
    add_slot_macro = Symbol("@add_slot")
    expr = Expr(:block)
    for op in syms
        macro_expr = Expr(:macrocall, add_slot_macro, @__LINE__, op)
        push!(expr.args, macro_expr)
    end
    Core.eval(mod, expr)
end # function eval_add_slot

"""
    macro add_slot(ops::Symbol...)
"""
macro add_slot(ops::Symbol...)
    mod = __module__
    eval_add_slot(mod, ops)
end # macro add_slot(ops::Symbol...)

@add_slot AND OR XOR NOT

"""
```
struct AND{T} <: AbstractSlot{T}
    elements::Vector{T} where T
end
```
"""
AND


"""
```
struct OR{T} <: AbstractSlot{T}
    elements::Vector{T} where T
end
```
"""
OR


"""
```
struct XOR{T} <: AbstractSlot{T}
    elements::Vector{T} where T
end
```
"""
XOR


"""
```
struct NOT{T} <: AbstractSlot{T}
    elements::Vector{T} where T
end
```
"""
NOT

for (f, Op) in ((:wedge, :AND),
                (:vee,   :OR),
                (:oplus, :XOR),
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
const ⊕ = oplus
const ¬ = neg

# baremodule LogicalOperators
