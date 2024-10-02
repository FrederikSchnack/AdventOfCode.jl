module Day06

    using ..AdventOfCode22

    """
        day06()

    Solves the two puzzles of day 6. 
    """
    function day06(input::String = readInput(6))
        s0 = 0
        s1 = 0
        s0_done = false
        chars = Dict{Char, Int}()
        start = 1

        for (count, c) in enumerate(input)
            if !s0_done && (count - start) == 4 
                    s0 = count - 1
                    s0_done = true
            end
            if (count - start) == 14
                s1 = count-1
                break
            end

            if haskey(chars, c) && chars[c] ≥ start
                start = chars[c] + 1
            end
            chars[c] = count
        end
  
        return [s0, s1]
    end


end # module