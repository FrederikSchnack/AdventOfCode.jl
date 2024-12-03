module Day03
    using ..AdventOfCode24

    """
        day03()

    Solves the two puzzles of day 03. 
    """

    function day03(input::String = readInput(03))

        s0 = mul(input)
        s1 = 0

        for l in split(input, "do()")

            i = findfirst("don't()", l)
            !isnothing(i) && (l = first(l, first(i)))

            s1 += mul(l)
        end

        return [s0, s1]
    end

    function mul(ops::AbstractString)
        r = r"mul\((\d+),(\d+)\)"
        s = 0
        for m in eachmatch(r, ops)
            a = parse(Int, m.captures[1])
            b = parse(Int, m.captures[2])
            s += a*b
        end

        return s
    end

end 

