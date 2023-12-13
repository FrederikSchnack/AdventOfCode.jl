module Day11
    using ..AdventOfCode23

    """
        day11()

    Solves the two puzzles of day 11. 
    """

    function day11(input::String = readInput(11))
        lines = split(input, "\n")
        n = length(lines[1])
        r = r"(\#)"

        col = cumsum([isnothing(findfirst(r, input[i:n+1:end])) for i in 1:n]) 
        lin = cumsum([isnothing(findfirst(r, l)) for l in lines]) 

        galaxies = Set{Tuple{Int, Int}}()


        for (x,l) in enumerate(lines)
            inds = findall(r, l)

            for i in inds
                push!(galaxies, (x, i.start))
            end

        end

        s0 = 0
        s1 = 0
        for a in galaxies
            ax, ay = a

            for b in galaxies
                bx, by = b
                s0 += abs(ax + lin[ax] - bx - lin[bx]) + abs(ay + col[ay] - by - col[by])
                s1 += abs(ax + 999999 * lin[ax] - bx - 999999 * lin[bx]) + abs(ay + 999999 * col[ay] - by - 999999 * col[by])
            end

            delete!(galaxies, a)
        end



        return [s0, s1]
    end
end 

