module Day12
    using ..AdventOfCode23
    using Memoize

    """
        day12()

    Solves the two puzzles of day 12. 
    """

    function day12(input::String = readInput(12))
        lines = split(input, "\n")

        s0 = 0
        s1 = 0
        for (l, n) in split.(lines)
            seq = [parse(Int, nn.match) for nn in eachmatch(r"(\d+)", n)]
            l_0 = string(l)*'.'
            s0 += solve_step(l_0, seq, 1, 1, 0)

            l_1 = (l*'?')^5
            l_1 = l_1[1:end-1] * '.'
            seq_1 = vcat([seq for _ in 1:5]...)
            s1 += solve_step(l_1, seq_1, 1, 1, 0)
        end

        return [s0, s1]
    end


    @memoize function solve_step(line::String, seq::Vector{Int}, pos::Int, num::Int, hash::Int)
        if pos == length(line)+1
            return Int(num == length(seq)+1)
        end
        if (num <= length(seq)) && (hash > seq[num])
            return 0
        end

        r = 0

        if line[pos] in ('#', '?')
            r += solve_step(line, seq, pos+1, num, hash+1)
        end

        if line[pos] in ('.', '?')
            if hash > 0 
                if num <= length(seq) && hash == seq[num]
                    r += solve_step(line, seq, pos+1, num+1, 0)
                end
            else
                r += solve_step(line, seq, pos+1, num, 0)
            end
        end

        return r
    end
   
end 

