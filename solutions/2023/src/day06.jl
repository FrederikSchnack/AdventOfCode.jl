 module Day06
    using ..AdventOfCode23

    """
        day06()

    Solves the two puzzles of day 06. 
    """

    function day06(input::String = readInput(06))
        lines = split(input, "\n")
        r = r"(\d+)"

        times = (x -> lines[1][x]).(findall(r, lines[1]))
        dists = (x -> lines[2][x]).(findall(r, lines[2]))

        s0 = prod(@. solve(parse(Int, times),parse(Int, dists)))
        s1 = solve(parse(Int, prod(times)), parse(Int, prod(dists)))

        return [s0, s1]

    end

    function solve(max_time::Int, min_dist::Int)
        return  ceil(Int,(-max_time - sqrt(max_time^2 - 4*min_dist))/(-2)-1) - floor(Int, 1+(-max_time + sqrt(max_time^2 - 4*min_dist))/(-2)) + 1
    end
end 

