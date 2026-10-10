baremodule LogicalOperators

using Base: Base, @__MODULE__

export @logic
Base.include(@__MODULE__, "logic.jl")

# AND, OR, XOR, NOT
# ∧,   ∨,  ⊕,   ¬
Base.include(@__MODULE__, "slots.jl")

end # baremodule LogicalOperators
