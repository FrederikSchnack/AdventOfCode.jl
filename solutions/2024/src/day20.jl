module Day20
    using ..AdventOfCode24
    using DataStructures

    """
        day20()

    Solves the two puzzles of day 20. 
    """

    function day20(input::String = readInput(20))
        lines = split(input)
        n,m = length(lines[1]), length(lines)
        grid = [lines[i][j] for i in 2:n-1, j in 2:m-1]
        S = findfirst(==('S'), grid)
        E = findfirst(==('E'), grid)

        s0, s1 = find_path(S, E, grid)

        return [s0, s1]
    end

    const dir = (CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1))
    const cheating1 = 2 .* dir
    const cheating2 = Tuple(CartesianIndex(x, y) for x in  -20:20 for y in -20:20 if abs(x)+abs(y)<=20)


    function find_path(start::CartesianIndex{2}, goal::CartesianIndex{2}, grid::Matrix{Char})

        not_visited = Tuple{Int, CartesianIndex{2}}[(0, start)]
        visited = Dict{CartesianIndex{2}, Int}()
        cheats = Dict{CartesianIndex{2}, Vector{CartesianIndex{2}}}()
        cheats2 = Dict{CartesianIndex{2}, Vector{CartesianIndex{2}}}()

        while !isempty(not_visited)
            s, curr = heappop!(not_visited)

            haskey(visited, curr) && continue
            visited[curr] = s

            if curr == goal 
                break
            end

                
            cheats[curr] = [curr + d for d in cheating1 if get(grid, curr+d, '#') in ".E"]
            cheats2[curr] = [curr + d for d in cheating2 if get(grid, curr+d, '#') in ".E"]

            for d in dir
                next = curr + d
                !checkbounds(Bool, grid, next) && continue
                grid[next] == '#' && continue
                heappush!(not_visited, (s+1, next))
            end

        end


        s0 = calculate_save(cheats, visited)
        s1  = calculate_save(cheats2, visited)

        return [s0, s1]
    end


    function calculate_save(cheats::Dict{CartesianIndex{2}, Vector{CartesianIndex{2}}}, visited::Dict{CartesianIndex{2}, Int})
        s = 0
        for (c,d) in cheats
            for dd in d          
                dif = (visited[dd] - visited[c]) - sum(abs, (c-dd).I)
                dif >= 100 && (s+=1)
            end
        end
        return s
    end

end