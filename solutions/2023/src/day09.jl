module Day09
    using ..AdventOfCode23

    """
        day09()

    Solves the two puzzles of day 09. 
    """

    function day09(input::String = readInput(09))
        lines = split(input, "\n")
        re = r"(-*\d+)"

        s0 = 0
        s1 = 0

        for l in lines
            h = [parse(Int, l[i]) for i in findall(re, l)]
            f, l = next_history(h)
            s0 += l
            s1 += f
        end

        return [s0, s1]
    end

    function next_history(hist::Vector{Int})
        ff = hist[1]
        ll = hist[end]
        n = length(hist)

        for k in 1:n-1
            hist[k] = hist[k+1] - hist[k]
        end

        deleteat!(hist, n)

        iszero(hist) && return ff, ll 

        f, l = next_history(hist)
        return ff - f, l + ll
    end
end 

