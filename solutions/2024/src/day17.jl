module Day17
    using ..AdventOfCode24

    """
        day17()

    Solves the two puzzles of day 17. 
    """

    function day17(input::String = readInput(17))
        lines = split(input, "\n\n")
        reg = r"""Register A: (\d+)
                Register B: (\d+)
                Register C: (\d+)"""

        register = parse.(Int, match(reg, lines[1]))
        program = [parse(Int, m.captures[1]) for m in eachmatch(r"(\d+)", lines[2])]

        s0 = to_string(run(program, register))
        s1 = calc_digit(0, 1, program)

        return [s0, s1]
    end



    function calc_digit(a::Int, d::Int, program::Vector{Int})

        d == length(program)+1 && return a 

        for k in 0:7

            register = [a * 8 +  k, 0, 0]
            output = run(program, register)

            if output[1] == program[end-d+1]
                v = calc_digit(a * 8 + k, d+1, program)
                !isnothing(v) && return v
            end
        end

        return nothing
    end

    function run(program::Vector{Int}, register::Vector{Int})
        n = length(program)
        output = Int[]

        k = 1
        while k < n
            i, o = program[k:k+1]
            verbose = execute_command(i, o, register)
            !isnothing(verbose) && push!(output, verbose)
            (i == 3 && register[1] != 0) ? (k = o+1) : (k += 2)
        end

        return output
    end

    function to_string(v::Vector{Int})
        return prod(string.(v).*',')[begin:end-1]
    end

    function execute_command(i::Int, op::Int, register::Vector{Int})
        i == 0 && return adv(op, register)
        i == 1 && return bxl(op, register)
        i == 2 && return bst(op, register)
        i == 3 && return jnz(op, register)
        i == 4 && return bxc(op, register)
        i == 5 && return out(op, register)
        i == 6 && return bdv(op, register)
        i == 7 && return cdv(op, register)
    end

    function combo(op::Int, register::Vector{Int})
        op == 0 && return 0
        op == 1 && return 1
        op == 2 && return 2
        op == 3 && return 3
        op == 4 && return register[1]
        op == 5 && return register[2]
        op == 6 && return register[3]
        op == 7 && return nothing
    end

    function adv(op::Int, register::Vector{Int})
        n = register[1]
        d = 2^combo(op, register)
        register[1] = Int(fld(n, d))
        return nothing
    end

    function bxl(op::Int, register::Vector{Int})
        register[2] = xor(op, register[2])
        return nothing
    end

    function bst(op::Int, register::Vector{Int})
        register[2] = mod(combo(op, register), 8)
        return nothing
    end

    function jnz(op::Int, register::Vector{Int})
        register[1] == 0 && return nothing
        return nothing
    end

    function bxc(op::Int, register::Vector{Int})
        register[2] = xor(register[2], register[3])
        return nothing
    end

    function out(op::Int, register::Vector{Int})
        return mod(combo(op, register), 8)
    end

    function bdv(op::Int, register::Vector{Int})
        n = register[1]
        d = 2^combo(op, register)
        register[2] = Int(fld(n, d))
        return nothing
    end

    function cdv(op::Int, register::Vector{Int})
        n = register[1]
        d = 2^combo(op, register)
        register[3] = Int(fld(n, d))
        return nothing
    end
end 

