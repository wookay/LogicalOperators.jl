using LogicalOperators

verbose = haskey(ENV, "CI")
if verbose
@info typeof(stdout)
end
# verbose = true
debug_logic(; verbose)
