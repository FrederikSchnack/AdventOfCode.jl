module Day01
    using ..AdventOfCode21

    """
        day01()

    Solves the two puzzles of day 1. 
    """
    function day01(input::String = readInput(1))
        s0 = 0
        s1 = 0
        lines = parse.(Int, split(input, "\n"))
        n = length(lines)
        for l in eachindex(lines)[1:end-1]
            s0 += (lines[l+1] > lines[l]) ? 1 : 0
            l < n-2 && (s1 += (sum(lines[l+1:l+3]) > sum(lines[l:l+2])) ? 1 : 0)
        end

        return [s0, s1]
    end

end
