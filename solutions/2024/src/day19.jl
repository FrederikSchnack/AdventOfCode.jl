module Day19
    using ..AdventOfCode24
    using Memoize

    """
        day19()

    Solves the two puzzles of day 19. 
    """

    function day19(input::String = readInput(19))
        blocks = split(input, "\n\n")
        paterns = [string(m.captures[1]) for m in eachmatch(r"(\w+)\,?", blocks[1])]
        towels = [string(m.captures[1]) for m in eachmatch(r"(\w+)\n?", blocks[2])]

        s = [score_towel(t, paterns) for t in towels]
        s0 = sum(s .> 0)
        s1 = sum(s)

        return [s0, s1]
    end


@memoize function score_towel(towel::String, paterns::Vector{String})
        isempty(towel) && return 1

        s = 0

        for i in 1:min(length(towel), maximum(length.(paterns)))

            if towel[1:i] in paterns
                s += score_towel(towel[i+1:end], paterns)
            end

        end

        return s
    end

end 

