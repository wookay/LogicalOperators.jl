# baremodule LogicalOperators

using .Base: :, first, string, repeat,
             print, println, printstyled, stdout,
             VERSION, @v_str, >=

function debug_bitwise(mod::Module, expr::Expr)
    op = first(expr.args)
    x = expr.args[2]
    y = expr.args[3]
    println(stdout, "  ", string(x, base=2, pad=8))
    printstyled(stdout, op; color = :cyan)
    print(stdout, " ")
    println(stdout, string(y, base=2, pad=8))
    println(stdout, repeat('-', 10))
    result = Core.eval(mod, expr)
    println(stdout, "  ", string(result, base=2, pad=8))
end # function debug_bitwise

function debug_boolean_body(mod::Module, op::Symbol, ex::Expr)::Bool
    ret = Core.eval(mod, ex)
    if ret
        printstyled(stdout, ex; color = :green)
    else
        if VERSION >= v"1.17" # printstyled(; underline)
            printstyled(stdout, ex; color = :red, underline = true)
        else
            printstyled(stdout, ex; color = :red)
        end
    end
    ret
end # function debug_boolean_body

function debug_boolean(mod::Module, expr::Expr)
    debug_more = false
    op = expr.head
    ex = first(expr.args)
    if op === :(&&)
       debug_boolean_body(mod, op, ex)
       debug_more = true
    elseif op === :(||)
       debug_boolean_body(mod, op, ex)
       debug_more = true
    else
       debug_boolean_body(mod, op, expr)
    end
    if debug_more
        print(stdout, " ")
        printstyled(stdout, op; color = :cyan)
        print(stdout, " ")
        debug_boolean(mod, expr.args[2:end]...)
    else
        println(stdout)
    end
end # function debug_boolean

"""
    macro logic(expr::Expr)
"""
macro logic(expr::Expr)
    if expr.head === :call
        debug_bitwise(__module__, expr)
    else
        debug_boolean(__module__, expr)
    end
    esc(expr)
end # macro logic

# baremodule LogicalOperators
