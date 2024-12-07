module Day06
    using ..AdventOfCode24

    """
        day06()

    Solves the two puzzles of day 06. 
    """

    function day06(input::String = readInput(06))
        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]
        obs =  Set(findall(==('#'), grid))
        pos = findfirst(==('^'), grid)

        G = Guard(pos, 
                CartesianIndex(-1,0), 
                Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}( pos => Set([CartesianIndex(-1,0)]) ), 
                obs)

        move!(G, grid)
        s0 = length(G.visited)

        blocks = Set{CartesianIndex{2}}()
        s1 = 0
        for (gpos, setdir) in G.visited
            for gdir in setdir
                b = gpos + gdir

                if b in blocks || b in obs
                    continue
                end
                push!(blocks, b)

                F = Guard(pos, 
                        CartesianIndex(-1,0),
                        Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}( pos => Set([CartesianIndex(-1,0)]) ),
                        union(Set([b]), obs))

                if isloop(F, grid) 
                    (s1 += 1)
                end
            end
        end
      


        
        return [s0, s1]
    end

    mutable struct Guard
        pos::CartesianIndex{2}
        dir::CartesianIndex{2}
        visited::Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}
        obs::Set{CartesianIndex{2}}
    end


    function move!(G::Guard, grid::Matrix{Char})
            
        while checkbounds(Bool, grid, G.pos+G.dir)
            if G.pos+G.dir ∈ G.obs
                G.dir = turn[G.dir]
            else
                G.pos += G.dir
            end

            if haskey(G.visited, G.pos)
                push!(G.visited[G.pos], G.dir)
            else
                G.visited[G.pos] = Set([G.dir])
            end

        end
        
    end
    
    function isloop(G::Guard, grid::Matrix{Char})
        
        while checkbounds(Bool, grid, G.pos+G.dir)


            if G.pos+G.dir ∈ G.obs
                G.dir = turn[G.dir]
            else
                G.pos += G.dir
            end
        
            if haskey(G.visited, G.pos)
                G.dir ∈ G.visited[G.pos] && return true
                push!(G.visited[G.pos], G.dir)
            else
                G.visited[G.pos] = Set([G.dir])
            end

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