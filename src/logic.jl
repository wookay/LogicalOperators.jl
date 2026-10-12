# baremodule LogicalOperators

using .Base: !, :, ∘, +, -,
             ndigits, min, max, iszero,
             in, findfirst, first, length, bitstring, string, lpad,
             Bool, Vector, isempty, push!, pop!,
             print, println, printstyled, stdout,
             VERSION, @v_str, >=

struct BitwiseUnit
    op::Union{Nothing, Symbol}
    bin
    num
    calculated::Bool
end

struct BitwiseOp
    lhs
    calc_already::Bool
end

struct BitwiseState
    output::Vector{BitwiseUnit}
    stack::Vector{BitwiseOp}
    BitwiseState() = new([], [])
end

function get_bin_pad(x)
    bitstr = bitstring(x)
    first_one_idx = findfirst(==('1'), bitstr)
    nbit = iszero(x) ? 2 : 8
    bitsize = VERSION >= v"1.14-DEV" ? min(Core.bitsizeof(x), nbit) : nbit
    bin_pad = first_one_idx === nothing ? bitsize : length(bitstr) - first_one_idx + 1
    return bin_pad
end # function get_bin_pad

function print_0b(io::IO)
    printstyled(io, "0b"; color = :light_black)
end # function print_0b

function print_bitwise_output(io::IO, mod::Module, state::BitwiseState)
    (op_pad, bin_pad, num_pad) = (0, 2, 0)
    for unit in state.output
        op_pad  = max(op_pad,  unit.op === nothing ? 2 : length(String(unit.op)))
        bin_pad = max(bin_pad, get_bin_pad(unit.bin))
        num = unit.num isa Symbol ? Core.getglobal(mod, unit.num) : unit.num
        num_pad = max(num_pad, ndigits(num))
    end
    for unit in state.output
        if unit.op === nothing
            print(io, lpad("", op_pad))
        else
            printstyled(io, lpad(unit.op, op_pad); color = :cyan)
        end
        print(io, " ")
        print_0b(io)
        print(io, string(unit.bin, base=2, pad=bin_pad), " ")
        str_num = lpad(string(unit.num), num_pad)
        if unit.calculated
            printstyled(io, str_num; color = :green)
        else
            print(io, str_num)
        end
        println(io)
    end
    !Base.isinteractive() && println(io)
end # function print_bitwise_output

function bitwise_expr(mod::Module, state::BitwiseState, op::Symbol, ex::Expr)
   rhs = Core.eval(mod, ex)
   bitwise_operation(mod, state, false, rhs, ex.args...)
   if isempty(state.stack)
       push!(state.stack, BitwiseOp(rhs, true))
   else
       unit = pop!(state.stack)
       evaluated = Core.eval(mod, Expr(:call, op, unit.lhs, rhs))
       bitwise_operation(mod, state, false, evaluated, op, unit.lhs, rhs)
   end
end # function bitwise_expr ex::Expr

function bitwise_expr(mod::Module, state::BitwiseState, op::Symbol, x)
   if isempty(state.stack)
       push!(state.stack, BitwiseOp(x, false))
   else
       unit = pop!(state.stack)
       ex = Expr(:call, op, unit.lhs, x)
       calculated = Core.eval(mod, ex)
       bitwise_operation(mod, state, unit.calc_already, calculated, ex.args...)
   end
end # function bitwise_expr x

function bitwise_calculated(mod::Module, state::BitwiseState, calculated)
    push!(state.output, BitwiseUnit(nothing, calculated, calculated, true))
    return calculated
end # function bitwise_calculated

function bitwise_operation(mod::Module, state::BitwiseState, calc_already::Bool, calculated, op::Symbol, x, y)
    if !calc_already
        nx = x isa Symbol ? Core.getglobal(mod, x) : x
        push!(state.output, BitwiseUnit(nothing, nx, x, false))
    end

    ny = y isa Symbol ? Core.getglobal(mod, y) : y
    push!(state.output, BitwiseUnit(op, ny, y, false))

    bitwise_calculated(mod, state, calculated)
    return calculated
end # function bitwise_operation

function debug_bitwise(io::IO, mod::Module, expr::Expr)
    op = first(expr.args)
    if op === :identity
        calculated = expr.args[2]
        state = BitwiseState()
        bitwise_calculated(mod, state, calculated)
        print_bitwise_output(io, mod, state)
        return calculated
    elseif op in (:(&), :(|), :(⊻), :(<<), :(>>), Symbol("<<<"), Symbol(">>>"))
        state = BitwiseState()
        for x in expr.args[2:end]
            bitwise_expr(mod, state, op, x)
        end
        print_bitwise_output(io, mod, state)
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
