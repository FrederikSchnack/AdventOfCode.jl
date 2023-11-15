module Day04

    using ..AdventOfCode22


    """
        day04()

    Solves the two puzzles of day 4. 
    """
    function day04(input::String = readInput(4))
        s0 = 0
        s1 = 0

        for line in split(input, "\n")
            lr = parse.(Int, split(line, ('-', ',')))
            l_int = max(lr[1], lr[3])
            r_int = min(lr[2], lr[4])

            if (l_int == lr[1] && r_int == lr[2]) || (l_int == lr[3] && r_int == lr[4])
                s0 += 1
            end

            if l_int ≤ r_int 
                s1 += 1
            end
        end

        return [s0, s1]
    end


end # module