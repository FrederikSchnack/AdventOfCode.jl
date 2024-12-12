module Day12
    using ..AdventOfCode24

    """
        day12()

    Solves the two puzzles of day 12. 
    """

    function day12(input::String = readInput(12))
        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]
        visited = Set{CartesianIndex{2}}()

        s0 = 0
        s1 = 0
        for k in eachindex(IndexCartesian(), grid)

            k ∈ visited && continue 
            area, fences, sides = floodfill(grid, visited, k) 
            s0 += area * fences
            s1 += area * sides
        end

        return [s0, s1]
    end

    function floodfill(grid::Matrix{Char}, visited::Set{CartesianIndex{2}}, k::CartesianIndex{2})
        stack = Set{CartesianIndex{2}}([k])
        p = grid[k]
        size = 0
        fences = 0
        corners = 0

        while !isempty(stack)

            k = pop!(stack)
            push!(visited, k)
            
            size += 1
            corners += check_corner(grid, k)

            for j in directions
                next = k + j
                if checkbounds(Bool, grid, next) && grid[next] == p 
                    !(next in visited) && push!(stack, next)
                else
                    fences += 1
                end
            end

        end
        
        return size, fences, corners
    end

    function check_corner(grid::Matrix{Char}, k::CartesianIndex{2})
        c = 0
        p = grid[k]
        for (d1, d2, d3) in corners
            c1 = get(grid, k + d1, ' ')
            c2 = get(grid, k + d2, ' ')
            c3 = get(grid, k + d3, ' ')

            if (p != c1 && p != c2)  || p == c1 == c2 != c3
                c += 1
            end
        end

        return c
    end

    const directions = (CartesianIndex(1, 0), CartesianIndex(0, 1),CartesianIndex(-1, 0), CartesianIndex(0, -1))

    const corners = ((CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(-1, -1)),
                    (CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(1, -1)),
                    (CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(1, 1)),
                    (CartesianIndex(-1, 0),CartesianIndex(0, 1), CartesianIndex(-1, 1)))
end 

