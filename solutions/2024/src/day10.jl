module Day10
    using ..AdventOfCode24

    """
        day10()

    Solves the two puzzles of day 10. 
    """

    function day10(input::String = readInput(10))
        lines = split(input)
        grid = [parse(Int, lines[i][j]) for i in eachindex(lines), j in eachindex(lines[1])]

        s0 = 0
        s1 = 0

        for z in findall(==(0), grid)

            top = Dict{CartesianIndex{2}, Int}()

            for d in directions
               step!(z, d, grid, top)
            end

            for (_, v) in top
                s0 += 1
                s1 += v
            end
        end

        return [s0, s1]

    end


    function step!(pos::CartesianIndex{2}, dir::CartesianIndex{2}, grid::Matrix{Int}, top::Dict{CartesianIndex{2}, Int})
        next = pos + dir
        
        !checkbounds(Bool, grid, next) && return 
        1 != grid[next] - grid[pos] && return 

        if grid[next] == 9 
            haskey(top, next) ? (top[next] += 1) : (top[next] = 1)
            return
        end

        
        for d in directions
            step!(next, d, grid, top)
        end

        return 
    end

    const directions = (CartesianIndex(1, 0), CartesianIndex(0, 1), 
    CartesianIndex(-1, 0), CartesianIndex(0, -1))


end 

