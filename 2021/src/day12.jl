module Day12
    using ..AdventOfCode21

    """
        day12()

    Solves the two puzzles of day 12. 
    """
    function day12(input::String = readInput(12))
        
        edges = Dict{String, Set{String}}()
        for l in split(input, "\n")
            a, b = split(l, "-")

            !haskey(edges, a) && (edges[a] = Set{String}())
            !haskey(edges, b) && (edges[b] = Set{String}())

            push!(edges[a], b)
            push!(edges[b], a)
        end

        s0 = dfs(edges, ["start"])
        s1 = dfs_extra(edges, ["start"])

        return [s0, s1]
    end


    function dfs(edges::Dict{String, Set{String}}, path::Vector{String})
        s0 = 0

        (path[end] == "end") && return 1

        for w in edges[path[end]]
            
            if (isuppercase(w[1]) || !(w ∈ path)) 
                push!(path, w)
                (s0 += dfs(edges, path))
                pop!(path)
            end
            
        end

        return s0
    end

    function dfs_extra(edges::Dict{String, Set{String}}, path::Vector{String})
        s1 = 0
        
        (path[end] == "end") && return 1

        for w in edges[path[end]]
            (w == "start") && continue
            if isuppercase(w[1])
                push!(path, w)
                s1 += dfs_extra(edges, path)
                pop!(path)
            elseif w ∈ path 
                push!(path, w)
                s1 += dfs(edges, path)
                pop!(path)
            else
                push!(path, w)
                s1 += dfs_extra(edges, path)
                pop!(path)
            end
        end

        return s1
    end




end 
