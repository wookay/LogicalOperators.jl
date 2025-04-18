module LogicalOperators

export ∧, ∨, ¬

struct AND
    elements::Tuple
    function AND(x, y)
        new((x, y))
    end
    function AND(elements::Tuple)
        new(elements)
    end
end

struct OR
    elements::Tuple
    function OR(x, y)
        new((x, y))
    end
    function OR(elements::Tuple)
        new(elements)
    end
end

struct NOT
    x
end

wedge(x) = Base.Fix2(AND, x)
wedge(x::AND, y) = AND((x.elements..., y))
wedge(elements...) = AND(tuple(elements...))

vee(x) = Base.Fix2(OR, x)
vee(x::OR, y) = OR((x.elements..., y))
vee(elements...) = OR(tuple(elements...))

neg(x) = NOT(x)

const ∧ = wedge
const ∨ = vee
const ¬ = neg

end # module LogicalOperators
