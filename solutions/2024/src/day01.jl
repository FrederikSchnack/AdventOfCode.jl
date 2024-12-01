module Day01
    using ..AdventOfCode24
    using DataStructures

    """
        day01()

    Solves the two puzzles of day 01. 
    """

    function day01(input::String = readInput(01))
        lines = split(input, "\n")
        r = r"(\d+)\s*(\d+)"

        left = Int[]
        right = Int[]

        for l in lines
            d1, d2 = match(r, l).captures
        
            push!(left, parse(Int, d1))
            push!(right, parse(Int, d2))
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