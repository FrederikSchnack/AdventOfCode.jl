module Day11
    using ..AdventOfCode21

    """
        day11()

    Solves the two puzzles of day 11. 
    """
    function day11(input::String = readInput(11))

        levels = Dict{Tuple{Int, Int}, Int}()

        for (i, l) in enumerate(split(input, "\n"))
            for k in eachindex(l)
               levels[(i,k)] = parse(Int, l[k])
            end
        end

        s0 = 0
        exploded = Set{Tuple{Int,Int}}()

        for s1 in 1:500
            increase_levels!(levels)

            again = true

            while again
                again = false
                for (k,v) in levels
                    if v > 9
                        push!(exploded, k)
                        levels[k] = 0
                        increase_adjacent!(levels, exploded, k[1], k[2])
                        (s1 <= 100) && (s0 += 1)
                        again = true
                    end
                end
            end
            (length(exploded) == 100) && return [s0, s1]

            empty!(exploded)
        end

    end


    function increase_levels!(levels::Dict{Tuple{Int, Int}, Int})
        
        for k in keys(levels)
            levels[k] += 1 
        end

    end

    function increase_adjacent!(levels::Dict{Tuple{Int, Int}, Int}, exploded::Set{Tuple{Int, Int}}, i::Int, k::Int)
        (haskey(levels, (i+1,k)) && !((i+1,k) ∈ exploded)) &&( levels[(i+1,k)] += 1)
        (haskey(levels, (i-1,k)) && !((i-1,k) ∈ exploded)) && (levels[(i-1,k)] += 1)
        (haskey(levels, (i,k+1)) && !((i,k+1) ∈ exploded)) && (levels[(i,k+1)] += 1)
        (haskey(levels, (i,k-1)) && !((i,k-1) ∈ exploded)) && (levels[(i,k-1)] += 1)
        (haskey(levels, (i+1,k+1)) && !((i+1,k+1) ∈ exploded)) && (levels[(i+1,k+1)] += 1)
        (haskey(levels, (i+1,k-1)) && !((i+1,k-1) ∈ exploded)) && (levels[(i+1,k-1)] += 1)
        (haskey(levels, (i-1,k+1)) && !((i-1,k+1) ∈ exploded)) && (levels[(i-1,k+1)] += 1)
        (haskey(levels, (i-1,k-1)) && !((i-1,k-1) ∈ exploded)) && (levels[(i-1,k-1)] += 1)
    end
end 
