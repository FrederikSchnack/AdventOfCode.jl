module Day01
    using ..AdventOfCode25

    """
        day01()

    Solves the two puzzles of day 01. 
    """

    function day01(input::String = readInput(01))

        p = 50 
        s0 = 0
        s1 = 0

        for l in split(input, "\n")
            sgn = (-1)^(l[1]=='L') 
            d = parse(Int, l[2:end])

            s, d = divrem(d, 100)
            s1 += s

            pd = p + sgn * d

            (((pd < 0)  || (pd > 100)) && (p !=0)) && (s1 += 1)

            p = mod(pd, 100)

            s0 += (p == 0)
        end


        return [s0, s0+s1]
    end
end 

