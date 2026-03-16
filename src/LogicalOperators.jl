baremodule LogicalOperators

using Base: Base, @__MODULE__

# export AbstractLogicalOperator
Base.include(@__MODULE__, "types.jl")

# export @logical_operator, @logicals
Base.include(@__MODULE__, "macros.jl")

# export AND, OR, XOR, NOT
# export ∧,   ∨,  ⊕,   ¬
Base.include(@__MODULE__, "operators.jl")

end # baremodule LogicalOperators
