module Day01
    using ..AdventOfCode24
    using DataStructures

    """
        day01()

    Solves the two puzzles of day 01. 
    """

    function day01(input::String = readInput(01))
        left = Int[]
        right = Int[]
        
        r = r"(\d+)\s*(\d+)\n?"
        for m in eachmatch(r, input)
            push!(left, parse(Int, m.captures[1]))
            push!(right, parse(Int, m.captures[2]))
        end

        sort!(left)
        sort!(right)

        s0 = sum(abs.(left .- right))

        c = counter(right)

        s1 = 0
        for n in left
            s1 += n*c[n]
        end

        return [s0, s1]
    end
end