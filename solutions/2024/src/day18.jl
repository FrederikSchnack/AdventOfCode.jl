module Day18
    using ..AdventOfCode24
    using DataStructures

    """
        day18()

    Solves the two puzzles of day 18. 
    """

    const m = 70 

    function day18(input::String = readInput(18))
        r = r"(\d+)\,(\d+)"
        bytes = [CartesianIndex(parse.(Int, m.captures)...) for m in eachmatch(r, input)]
        S = CartesianIndex(0,0)
        E = CartesianIndex(m,m)

        s0 = find_path(S, E, bytes[1:1024])
        s1 = binarysearch(S, E, bytes, 1025, length(bytes))
        
        return [s0, s1]
    end

    const dir = (CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1))

    function find_path(start::CartesianIndex{2}, goal::CartesianIndex{2}, bytes::Vector{CartesianIndex{2}})

        not_visited = Tuple{Int, CartesianIndex{2}}[(0, start)]
        visited = Set{CartesianIndex{2}}()

        while !isempty(not_visited)
            s, curr = heappop!(not_visited)

            curr in visited && continue
            push!(visited, curr)
            if curr == goal 
                return s
            end
            
            for d in dir
                next = curr + d
                (next in bytes || !all(0 .<= next.I .<= m)) && continue
                heappush!(not_visited, (s+1, next))
            end

        end
    end

    function binarysearch(start::CartesianIndex{2}, goal::CartesianIndex{2}, bytes::Vector{CartesianIndex{2}}, low::Int, high::Int)
        (high - low == 1) && return "$(bytes[high].I[1]),$(bytes[high].I[2])"

        mid = (low + high) ÷ 2

        p = find_path(start, goal, bytes[1:mid])

        if !isnothing(p)
            return binarysearch(start, goal, bytes, mid, high)
        else
            return binarysearch(start, goal, bytes, low, mid)
        end
    end

end 

