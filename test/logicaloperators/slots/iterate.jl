module test_logicaloperators_iterate

using Test
using LogicalOperators: AND

vals = []
for el in AND(1, 2, 3)
    push!(vals, el)
end

@test vals == [1, 2, 3]

end # module test_logicaloperators_iterate
