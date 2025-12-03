module Day03
    using ..AdventOfCode25

    """
        day03()

    Solves the two puzzles of day 03. 
    """

    function day03(input::String = readInput(03))
        s0 = 0
        s1 = 0

        for l in split(input, "\n")
            s0 += get_max(l, 2)
            s1 += get_max(l, 12)
        end

        return [s0, s1]

    end

    function get_max(line::AbstractString, len::Int)
        val = ""
        prev_i = 0

        for d in 1:len
            v, i = findmax(line[prev_i+1:length(line)-len+d])
            line = line[prev_i+1:end]

            val *= v
            prev_i = i
        end

        return parse(Int, val)
    end
end 

