module Day05

    using ..AdventOfCode22

    """
        day05()

    Solves the two puzzles of day 5. 
    """
    function day05(input::String = readInput(5))
        setup, commands = split(input, "\n\n")
        m = parse(Int, setup[end-1])
        C = Dict{Int, Vector{Char}}(i => Char[] for i in 1:m)

        for layer in split(setup, "\n")[1:end-1]
            for (i, crate) in enumerate(layer[2:4:end])
                if crate !== ' '
                    push!(C[i], crate)
                end
            end
        end
        
        reg = r"move\s+(\d+)\s+from\s+(\d+)\s+to\s+(\d+)"
        operations = [parse.(Int, match(reg, op).captures) for op in split(commands, "\n")]
        
        C0 = deepcopy(C)

        for op in operations
            do_op_s0!(C0, op)
            do_op_s1!(C, op)
        end

        s0 = join([C0[i][1] for i in 1:m])
        s1 = join([C[i][1] for i in 1:m])

        return [s0, s1]
  
    end

    function do_op_s0!(C::Dict{Int, Vector{Char}}, operations::Vector{Int})
        for _ in 1:operations[1]
            pushfirst!(C[operations[3]], popfirst!(C[operations[2]]))
        end
    end

    function do_op_s1!(C::Dict{Int, Vector{Char}}, operations::Vector{Int})
        pushfirst!(C[operations[3]], splice!(C[operations[2]], 1:operations[1])...)
    end

end # module