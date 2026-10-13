# baremodule LogicalOperators

using .Base: !, :, ∘, +, -,
             ndigits, min, max, iszero, enumerate,
             in, findfirst, first, length, bitstring, string, lpad,
             Bool, Vector, isempty, push!, pop!,
             print, println, printstyled, stdout,
             VERSION, @v_str, >=

mutable struct DebugSettings
    verbose::Bool
end

const Debug = DebugSettings(true)

function debug_logic(; verbose::Bool = true)
    Debug.verbose = verbose
end

struct BitwiseUnit
    op::Union{Nothing, Symbol}
    bin
    num
    calculated::Bool
end

struct BitwiseOperand
    lhs
    calc_already::Bool
end

struct BitwiseState
    output::Vector{BitwiseUnit}
    stack::Vector{BitwiseOperand}
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

function println_if_is_not_interactive_and_is_a_tty(io::IO)
    !Base.isinteractive() && isa(io, Base.TTY) && println(io)
end # function println_if_is_not_interactive_and_is_a_tty

function print_bitwise_output(io::IO, mod::Module, state::BitwiseState)
    Debug.verbose || return
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
    println_if_is_not_interactive_and_is_a_tty(io)
end # function print_bitwise_output

function bitwise_expr(mod::Module, state::BitwiseState, op::Symbol, ex::Expr)
   rhs = Core.eval(mod, ex)
   bitwise_operation(mod, state, false, rhs, ex.args...)
   if isempty(state.stack)
       push!(state.stack, BitwiseOperand(rhs, true))
   else
       operand = pop!(state.stack)
       evaluated = Core.eval(mod, Expr(:call, op, operand.lhs, rhs))
       bitwise_operation(mod, state, false, evaluated, op, operand.lhs, rhs)
   end
end # function bitwise_expr ex::Expr

function bitwise_expr(mod::Module, state::BitwiseState, op::Symbol, x)
   if isempty(state.stack)
       push!(state.stack, BitwiseOperand(x, false))
   else
       operand = pop!(state.stack)
       ex = Expr(:call, op, operand.lhs, x)
       calculated = Core.eval(mod, ex)
       bitwise_operation(mod, state, operand.calc_already, calculated, ex.args...)
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
        debug_short_circuiting_booleans(io, mod, expr)
    end
end # function debug_bitwise

struct CircuitUnit
    expr
    boolean::Bool
end

struct CircuitExpr
    head::Symbol
    args::Vector{Any}
end

function print_boolean_output(io::IO, boolean::Bool, x)
    if boolean
        printstyled(io, x; color = :green)
    else
        if VERSION >= v"1.7"
            printstyled(io, x; color = :red, underline = true)
        else
            printstyled(io, x; color = :red)
        end
    end
end # function print_boolean_output

function print_circuit_output(io::IO, mod::Module, bool::Bool)
    print_boolean_output(io, bool, bool)
end # function print_circuit_output bool

function print_circuit_output(io::IO, mod::Module, unit::CircuitUnit)
    print_boolean_output(io, unit.boolean, unit.expr)
end # function print_circuit_output unit

function print_circuit_output(io::IO, mod::Module, circuit_expr::CircuitExpr)
    if circuit_expr.head in (:&& , :||)
        for (idx, unit) in enumerate(circuit_expr.args)
            with_parenthesis = unit isa CircuitExpr && unit.head === :|| && circuit_expr.head === :&&
            with_parenthesis && print(io, "(")
            print_circuit_output(io, mod, unit)
            with_parenthesis && print(io, ")")
            1 == idx && print(io, " ", circuit_expr.head, " ")
        end
    end
end # function print_circuit_output circuit_expr

function print_circuit_expr(io::IO, mod::Module, expr::Union{CircuitExpr, CircuitUnit})
    Debug.verbose || return
    print_circuit_output(io, mod, expr)
    println(io)
    println_if_is_not_interactive_and_is_a_tty(io)
end # function print_circuit_expr

function map_circuit_expr(mod::Module, expr::Expr)::Union{CircuitExpr, CircuitUnit}
    if expr.head in (:&& , :||)
        circuit_expr = CircuitExpr(expr.head, [])
        for arg in expr.args
            if arg isa Expr
                ex = map_circuit_expr(mod, arg)
                push!(circuit_expr.args, ex)
            else
                push!(circuit_expr.args, arg)
            end
        end
        circuit_expr
    else
        boolean = Core.eval(mod, expr)
        CircuitUnit(expr, boolean)
    end
end # function map_circuit_expr

function debug_short_circuiting_booleans(io::IO, mod::Module, unit::CircuitUnit)
    print_circuit_expr(io, mod, unit)
end # function debug_short_circuiting_booleans unit

function debug_short_circuiting_booleans(io::IO, mod::Module, expr::Expr)
    circuit_expr = map_circuit_expr(mod, expr)
    print_circuit_expr(io, mod, circuit_expr)
end # function debug_short_circuiting_booleans expr

"""
    macro logic(n::Integer)
"""
macro logic(n::Integer)
    io = stdout
    debug_bitwise(io, __module__, Expr(:call, :identity, n))
    n
end

"""
    macro logic(bool::Bool)
"""
macro logic(bool::Bool)
    io = stdout
    debug_short_circuiting_booleans(io, __module__, CircuitUnit(bool, bool))
    bool
end

"""
    macro logic(expr::Expr)
"""
macro logic(expr::Expr)
    io = stdout
    if expr.head === :call
        debug_bitwise(io, __module__, expr)
    else
        debug_short_circuiting_booleans(io, __module__, expr)
    end
    esc(expr)
end # macro logic

# baremodule LogicalOperators
