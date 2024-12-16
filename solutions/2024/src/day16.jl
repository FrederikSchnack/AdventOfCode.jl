module Day16
    using ..AdventOfCode24
    using DataStructures

    """
        day16()

    Solves the two puzzles of day 16. 
    """

    function day16(input::String = readInput(16))
        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]

        S = findfirst(==('S'), grid)
        E = findfirst(==('E'), grid)
        walls = findall(==('#'), grid)

        s0, s1 = find_path(S, E, walls)

        return [s0, s1]
    end

    const dir = (CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1))

    function find_path(start::CartesianIndex{2}, goal::CartesianIndex{2}, walls::Vector{CartesianIndex{2}})

        not_visited = Tuple{Int, CartesianIndex{2}, CartesianIndex{2}, Vector{CartesianIndex{2}}}[(0, start, CartesianIndex(0, 1), [start])]
        
        visited = Dict{Tuple{CartesianIndex{2},CartesianIndex{2}}, Int}()
        tiles = Set{CartesianIndex{2}}()
        min_s = Inf

        while !isempty(not_visited)
            s, curr, d_old, path = heappop!(not_visited)
            s > min_s && break

            get(visited, (curr,d_old), Inf) < s && continue
            visited[(curr,d_old)] = s

            if curr == goal && s <= min_s
                min_s = s
                union!(tiles, path)
                continue
            end
            
            for d in dir
                d == -d_old && continue

                next = curr + d
                next in walls && continue

                d==d_old ? (cost = 1) : (cost = 1001)
                next_path = append!([next], path)
                
                get(visited, (next, d), Inf) < s+cost && continue
                heappush!(not_visited, (s+cost, next, d, next_path))
            end

        end

        return min_s, length(tiles)
    end

end 
