module Day07
    using ..AdventOfCode21
    using Statistics

    """
        day07()

    Solves the two puzzles of day 7. 
    """
    function day07(input::String = readInput(7))
        
        pos = parse.(Int, split(input, ",")) 
        median_pos = round(Int, median(pos))

        s0 = sum( abs.(pos .- median_pos))

        mean_floor_pos = floor(Int, mean(pos))
        mean_ceil_pos = floor(Int, mean(pos))

        diff_floor = abs.(pos .- mean_floor_pos)
        diff_ceil = abs.(pos .- mean_ceil_pos)

        s1 = min(div(sum( diff_floor .* (diff_floor .+ 1)), 2 ),
                div(sum( diff_ceil .* (diff_ceil .+ 1)), 2 ))

        return [s0, s1]
    end

end 
