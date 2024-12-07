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

        s1 = 0
        for (gpos, setdir) in G.visited
            for gdir in setdir
                F = Guard(pos, 
                        CartesianIndex(-1,0),
                        Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}( pos => Set([CartesianIndex(-1,0)]) ),
                        union(obs, Set([gpos + gdir])))
                
                if isloop(F, grid) 
                    @show gpos
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
            G.pos+G.dir ∈ G.obs && (G.dir = turn[G.dir])

            G.pos += G.dir

            if haskey(G.visited, G.pos)
                push!(G.visited[G.pos], G.dir)
            else
                G.visited[G.pos] = Set([G.dir])
            end

        end
        
    end
    
    function isloop(G::Guard, grid::Matrix{Char})
        
        while checkbounds(Bool, grid, G.pos+G.dir)

            if haskey(G.visited, G.pos)
                G.dir ∈ G.visited[G.pos] && return true
                push!(G.visited[G.pos], G.dir)
            else
                G.visited[G.pos] = Set([G.dir])
            end
            
            G.pos+G.dir ∈ G.obs && (G.dir = turn[G.dir])
            G.pos += G.dir

            

            if haskey(G.visited, G.pos)
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

function read_matrix(file)
    l = readlines(file)
    [l[i][j] for i in eachindex(l), j in eachindex(l[1])]
end

function get_next_obstacle(m, cur, dir)
    while checkbounds(Bool, m, cur + dir)
        if m[cur + dir] == '#'
            return true, cur
        end
        cur = cur + dir
    end
    return false, cur
end

function will_loop(m)
    cur = findfirst(==('^'), m)
    dir = CartesianIndex(-1, 0)
    visited = Set()
    inside = true
    while inside == true
        if !((cur, dir) in visited)
            push!(visited, (cur, dir))
        else
            return true
        end
        inside, cur = get_next_obstacle(m, cur, dir)
        dir = turn_right(dir)
    end
    return false
end

turn_right(dir) = CartesianIndex(([0 1; -1 0] * [dir[1], dir[2]])...)

function part1(m)
    cur = findfirst(==('^'), m)
    dir = CartesianIndex(-1, 0)
    visited = zeros(Bool, size(m))
    visited[cur] = true
    inside = true
    while inside == true
        inside, next = get_next_obstacle(m, cur, dir)
        while cur != next
            cur = cur + dir
            visited[cur] = true
        end
        dir = turn_right(dir)
    end
    return sum(visited)
end

function part2(m)
    total = 0
    blocks = Set{CartesianIndex{2}}()
    for pos in CartesianIndices(m)
        if m[pos] != '.'
            continue
        end
        m2 = copy(m)
        m2[pos] = '#'
        if will_loop(m2) == true
            push!(blocks, pos)    
            total += 1
        end
    end
    return total, blocks
end

m = read_matrix(ARGS[1])
part1(m) |> println
part2(m) |> println