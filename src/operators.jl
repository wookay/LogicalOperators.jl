# baremodule LogicalOperators

# AND  ∧  \wedge
# OR   ∨  \vee
# XOR  ⊕  \oplus
# NOT  ¬  \neg

@logicals AND OR XOR NOT

"""
    AND{T} <: AbstractLogicalOperator{T}

∧  \\wedge
"""
AND

"""
    OR{T} <: AbstractLogicalOperator{T}

∨  \\vee
"""
OR

"""
    XOR{T} <: AbstractLogicalOperator{T}

⊕  \\oplus
"""
XOR

"""
    NOT{T} <: AbstractLogicalOperator{T}

¬  \\neg
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
