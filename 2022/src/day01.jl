module Day01

    using ..AdventOfCode22


    """
        day01()

    Solves the two puzzles of day 1. 
    """
    function day01(input::String = readInput(1))
        cals = map(x -> parse.(Int, split(x, "\n")) |> sum, split(input, "\n\n")) |> sort!
    
        return [cals[end], sum(cals[end-2:end])]
    end

end # module