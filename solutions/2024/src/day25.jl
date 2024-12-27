module Day25
    using ..AdventOfCode24

    """
        day25()

    Solves the two puzzles of day 25. 
    """

    function day25(input::String = readInput(25))
        
        keys = Vector{Int}[]
        locks = Vector{Int}[]

        for o in split(input, "\n\n")

            b = split(o, "\n")
            q = [[x=='#' for x in b[k]] for k in 2:6] |> sum
            b[1][1] == '#' ? push!(keys, q) : push!(locks, q)                
           
        end

        s0 = 0
        for k in keys, l in locks
            all(l+k .<= 5) && (s0 +=1)
        end

        return [s0]
    end
end 

