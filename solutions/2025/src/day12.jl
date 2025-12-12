module Day12
    using ..AdventOfCode25

    """
        day12()

    Solves the two puzzles of day 12. 
    """

    function day12(input::String = readInput(12))
        
        lines = split(input, "\n\n")
        gifts = Dict{Int, Int}()

        for l in lines[1:end-1]
            id = parse(Int, l[1]+1)
            gifts[id] = count(==('#'), l[4:end])

        end 

        s0 = 0
        for l in split(lines[end], "\n")

            tot_area = prod(parse.(Int, match(r"(\d+)x(\d+):", l))) 
            area = 0
            for (k, v) in enumerate(eachmatch(r"( \d+)", l))
                area += gifts[k] * parse(Int, v.captures[1])
            end

            tot_area >= 1.2 * area && (s0 += 1)
        end

        return [s0]
    end
end 

