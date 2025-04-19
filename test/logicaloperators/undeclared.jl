module test_logicaloperators_undeclared

using Test

if VERSION > v"1.11"
    warn_msg = if VERSION >= v"1.13.0-DEV.9"
        "WARNING: Imported binding LogicalOperators.^ was undeclared at import time during import to test_logicaloperators_undeclared.\n"
    else
        "WARNING: could not import LogicalOperators.^ into test_logicaloperators_undeclared"
    end
    @test_warn warn_msg            @eval(using LogicalOperators: ^) # U+005E
else
    @test_throws UndefVarError(:^) @eval(using LogicalOperators: ^) # U+005E
end

end # module test_logicaloperators_undeclared
