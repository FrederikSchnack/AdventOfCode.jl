module Day06
    using ..AdventOfCode24

    """
        day06()

    Solves the two puzzles of day 06. 
    """

    function day06(input::String = readInput(06))
        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]

        obs = findall(==('#'), grid)
        pos = findfirst(==('^'), grid)

        dir = CartesianIndex(-1,0)
        visited = Set{CartesianIndex{2}}([pos])

        move!(grid, pos, dir, visited, obs)
        s0 = length(visited)

        s1 = 0
        for b in visited

            b in obs && continue
            push!(obs, b)

            new_visited = Set{Tuple{CartesianIndex{2},CartesianIndex{2}}}([(pos,dir)])

            isloop(grid, pos, dir, new_visited,  obs) && (s1 += 1)

            pop!(obs)

        end
      

        return [s0, s1]
    end


    function move!(grid::Matrix{Char}, pos::CartesianIndex{2}, dir::CartesianIndex{2}, visited::Set{CartesianIndex{2}}, obs::Vector{CartesianIndex{2}})
            
        while checkbounds(Bool, grid, pos+dir)

            pos+dir ∈ obs ? (dir = turn[dir]) : (pos += dir)
            push!(visited, pos)

        end
        
    end
    
    function isloop(grid::Matrix{Char}, pos::CartesianIndex{2}, dir::CartesianIndex{2}, visited::Set{Tuple{CartesianIndex{2},CartesianIndex{2}}}, obs::Vector{CartesianIndex{2}})
            
        while checkbounds(Bool, grid, pos+dir)

            pos+dir ∈ obs ? (dir = turn[dir]) : (pos += dir)
            (pos, dir) ∈ visited && return true
            push!(visited, (pos, dir))
    
        end   

        return false
    end


    const turn = Dict{CartesianIndex{2}, CartesianIndex{2}}(
        CartesianIndex(0,1) => CartesianIndex(1,0),
        CartesianIndex(1,0) => CartesianIndex(0,-1),
        CartesianIndex(0,-1) => CartesianIndex(-1,0),
        CartesianIndex(-1,0) => CartesianIndex(0,1)
    )

end 