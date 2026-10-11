# baremodule LogicalOperators

using .Base: :, ∘, !, in, ndigits, max, first, string, lpad, repeat,
             Vector, isempty, push!, pop!,
             print, println, printstyled, stdout,
             VERSION, @v_str, >=

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
    printstyled(io, "0b"; color = :light_black)
end # function print_0b

struct BitwiseUnit
    op::Symbol
    lhs
    printed_already::Bool
end

struct BitwiseState
    stack::Vector{BitwiseUnit}
    BitwiseState() = new([])
end

function debug_bitwise_expr(io::IO, mod::Module, num_pad::Int, state::BitwiseState, op::Symbol, ex::Expr)
   if isempty(state.stack)
       rhs = Core.eval(mod, ex)
       debug_bitwise_body(io, mod, num_pad, false, rhs, ex.args...)
       push!(state.stack, BitwiseUnit(op, rhs, true))
   else
       rhs = Core.eval(mod, ex)
       debug_bitwise_body(io, mod, num_pad, false, rhs, ex.args...)
       unit = pop!(state.stack)
       evaluated = Core.eval(mod, Expr(:call, unit.op, unit.lhs, rhs))
       debug_bitwise_body(io, mod, num_pad, false, evaluated, unit.op, unit.lhs, rhs)
   end
end # function debug_bitwise_expr ex::Expr

function debug_bitwise_expr(io::IO, mod::Module, num_pad::Int, state::BitwiseState, op::Symbol, x)
   if isempty(state.stack)
       push!(state.stack, BitwiseUnit(op, x, false))
   else
       unit = pop!(state.stack)
       ex = Expr(:call, unit.op, unit.lhs, x)
       evaluated = Core.eval(mod, ex)
       debug_bitwise_body(io, mod, num_pad, unit.printed_already, evaluated, ex.args...)
   end
end # function debug_bitwise_expr x

function debug_bitwise_body(io::IO, mod::Module, num_pad::Int, printed_already::Bool, evaluated, op::Symbol, x, y)
    bin_pad = get_bin_pad(num_pad)
    if !printed_already
        print(io, lpad(" ", 2))
        print(io, " ")
        print_0b(io)
        print(io, string(x, base=2, pad=bin_pad), " ")
        print(io, lpad(x, num_pad))
        println(io)
    end

    printstyled(io, lpad(op, 2); color = :cyan)
    print(io, " ")
    print_0b(io)
    println(io, string(y, base=2, pad=bin_pad), " ", lpad(y, num_pad))

    debug_bitwise_result(io, mod, num_pad, evaluated)
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
        state = BitwiseState()
        for x in expr.args[2:end]
            debug_bitwise_expr(io, mod, num_pad, state, op, x)
        end
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
