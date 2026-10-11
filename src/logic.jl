# baremodule LogicalOperators

using .Base: :, ∘, in, ndigits, max, first, string, lpad, repeat,
             print, println, printstyled, stdout,
             VERSION, @v_str, >=
using .Base: @info #

function get_bin_pad(num_pad::Int)::Int
    Base.:(^)(2, num_pad)
end # function get_bin_pad

function get_max_ndigits(mod::Module, expr::Expr)::Int
    max_ndigits = 0
    for x in expr.args[2:end]
        if x isa Expr
            max_ndigits = max(max_ndigits, get_max_ndigits(mod, x))
        else
            max_ndigits = max(max_ndigits, ndigits(x))
        end
    end
    max_ndigits
end # function get_max_ndigits

function print_0b(io::IO)
    print(io, "0")
    printstyled(io, "b"; color = :gray)
end # function print_0b

function debug_bitwise_expr(io::IO, mod::Module, num_pad::Int, op::Symbol, ex::Expr; cont::Bool)
    if cont
        debug_bitwise_body(io, mod, num_pad, ex.args...; calculated = false)
    else
        Core.eval(mod, ex)
    end
end # function debug_bitwise_expr

function debug_bitwise_body(io::IO, mod::Module, num_pad::Int, op::Symbol, prev, x; calculated::Bool)
    if prev === nothing
        return x
    end
    bin_pad = get_bin_pad(num_pad)
    print(io, lpad(" ", 2))
    print(io, " ")
    print_0b(io)
    print(io, string(prev, base=2, pad=bin_pad), " ")
    if calculated
         printstyled(io, lpad(prev, num_pad); color = :green)
    else
         printstyled(io, lpad(prev, num_pad))
    end
    println(io)
    printstyled(io, lpad(op, 2); color = :cyan)
    print(io, " ")
    print_0b(io)
    println(io, string(   x, base=2, pad=bin_pad), " ", lpad(   x, num_pad))
    debug_bitwise_expr(io, mod, num_pad, op, Expr(:call, op, prev, x); cont = false)
end # function debug_bitwise_body

function debug_bitwise_result(io::IO, mod::Module, num_pad::Int, result)
    bin_pad = get_bin_pad(num_pad)
    print(io, lpad(" ", 2))
    print(io, " ")
    print_0b(io)
    print(io, string(result, base=2, pad=bin_pad), " ")
    printstyled(io, lpad(result, num_pad); color = :green)
    println(io)
    return result
end # function debug_bitwise_result

function debug_bitwise(io::IO, mod::Module, expr::Expr)
    op = first(expr.args)
    if op === :identity
        result = expr.args[2]
        num_pad = ndigits(result) 
        debug_bitwise_result(io, mod, num_pad, result)
    elseif op in (:&, :|)
        num_pad = get_max_ndigits(mod, expr)
        result = nothing
        for x in expr.args[2:end]
            if x isa Expr
                result = debug_bitwise_expr(io, mod, num_pad, op, x::Expr; cont = true)
            else
                result = debug_bitwise_body(io, mod, num_pad, op, result, x; calculated = false)
            end
        end
        debug_bitwise_result(io, mod, num_pad, result)
    else # short-circuiting booleans
        debug_boolean(io, mod, expr)
    end
end # function debug_bitwise

function debug_boolean_body(io::IO, mod::Module, op::Symbol, ex::Expr)::Bool
    ret = Core.eval(mod, ex)
    if ret
        printstyled(io, ex; color = :green)
    else
        if VERSION >= v"1.7" # printstyled(; underline)
            printstyled(io, ex; color = :red, underline = true)
        else
            printstyled(io, ex; color = :red)
        end
    end
    ret
end # function debug_boolean_body

function debug_boolean(io::IO, mod::Module, expr::Expr)
    debug_more = false
    op = expr.head
    ex = first(expr.args)
    if op === :(&&)
       debug_boolean_body(io, mod, op, ex)
       debug_more = true
    elseif op === :(||)
       debug_boolean_body(io, mod, op, ex)
       debug_more = true
    else
       debug_boolean_body(io, mod, op, expr)
    end
    if debug_more
        print(io, " ")
        printstyled(io, op; color = :cyan)
        print(io, " ")
        debug_boolean(io, mod, expr.args[2:end]...)
    else
        println(io)
    end
end # function debug_boolean


"""
    macro logic(n::Integer)
"""
macro logic(n::Integer)
    io = stdout
    debug_bitwise(io, __module__, Expr(:call, :identity, n))
end

"""
    macro logic(expr::Expr)
"""
macro logic(expr::Expr)
    io = stdout
    if expr.head === :call
        debug_bitwise(io, __module__, expr)
    else
        debug_boolean(io, __module__, expr)
    end
    esc(expr)
end # macro logic

# baremodule LogicalOperators
