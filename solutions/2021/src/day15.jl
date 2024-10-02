module Day15
    using ..AdventOfCode21
    using DataStructures

    """
        day15()

    Solves the two puzzles of day 15. 
    """
    function day15(input::String = readInput(15))
        risk = Dict{Tuple{Int, Int}, Int}()

        n = findfirst('\n',input) - 1

        for (i, l) in enumerate(split(input, "\n"))
            for k in eachindex(l)
                for e in 0:4
                    for s in 0:4
                        risk[i+s*n, k+e*n] = mod1((parse(Int, l[k]) + s + e), 9)
                    end
                end
            end
        end

        s0 = find_path(risk, (1,1), (n,n), n)
        s1 = find_path(risk, (1,1), (5*n, 5*n), 5*n)

        return [s0, s1]

    end


    function find_path(risk_dict::Dict{Tuple{Int, Int}, Int}, start::Tuple{Int, Int}, goal::Tuple{Int, Int}, limit::Int)
        
        
        not_visited = Tuple{Int, Tuple{Int, Int}}[(0, start)]
        visited = Set{Tuple{Int, Int}}()

        while !isempty(not_visited)

            risk, curr = heappop!(not_visited)

            curr == goal && return risk
            curr ∈ visited && continue

            for next in next_coord(curr)
                !all((1,1) .<= next .<= (limit,limit)) && continue
                heappush!(not_visited, (risk + risk_dict[next], next))
            end

            push!(visited, curr)
        end
    end

    function next_coord(curr::Tuple{Int, Int})

        return ((curr[1]+1, curr[2]), (curr[1]-1, curr[2]),
                (curr[1], curr[2]+1), (curr[1], curr[2]-1))
    end

end 
