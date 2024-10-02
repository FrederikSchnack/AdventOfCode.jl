module Day17
    using ..AdventOfCode23
    using DataStructures

    """
        day17()

    Solves the two puzzles of day 17. 
    """

    function day17(input::String = readInput(17))
        heat = Dict{CartesianIndex{2}, Int}()

        n = findfirst('\n',input) - 1

        for (i, l) in enumerate(split(input, "\n"))
            for k in eachindex(l)
                heat[CartesianIndex(i, k)] = parse(Int, l[k])
            end
        end

        s0 = find_path(heat, CartesianIndex(1,1), CartesianIndex(n,n), n)
        s1 = find_ultra_path(heat, CartesianIndex(1,1), CartesianIndex(n,n), n)

        return [s0, s1]
    end
    
    function find_path(heat_dict::Dict{CartesianIndex{2}, Int}, start::CartesianIndex{2}, goal::CartesianIndex{2}, limit::Int)
    
    
        not_visited = Tuple{Int, CartesianIndex{2}, CartesianIndex{2}, Int}[(0, start, CartesianIndex(0,0), 0)]
        visited = Set{Tuple{CartesianIndex{2}, CartesianIndex{2}, Int}}()

        while !isempty(not_visited)

            heat, curr, dir, count = heappop!(not_visited)
            curr == goal && return heat
            (curr, dir, count) ∈ visited && continue
    
            for d in next_coord(dir, count)
                next = curr + d
                !all((1,1) .<= next.I .<= (limit,limit)) && continue

                if d == dir
                    heappush!(not_visited, (heat + heat_dict[next], next, dir, count+1))
                else
                    heappush!(not_visited, (heat + heat_dict[next], next, d, 1))
                end

            end
    
            push!(visited, (curr, dir, count))
        end
    end

    function next_coord(d::CartesianIndex{2}, c::Int)

        next = [CartesianIndex(1,0), CartesianIndex(0,1), CartesianIndex(-1, 0), CartesianIndex(0, -1)]
        !iszero(d) && deleteat!(next, findfirst(x->x==-d, next))

        if c == 3
            deleteat!(next, findfirst(x->x==d, next))
        end

        return next
    end

    function find_ultra_path(heat_dict::Dict{CartesianIndex{2}, Int}, start::CartesianIndex{2}, goal::CartesianIndex{2}, limit::Int)
    
    
        not_visited = Tuple{Int, CartesianIndex{2}, CartesianIndex{2}, Int}[(0, start, CartesianIndex(0,0), 0)]
        visited = Set{Tuple{CartesianIndex{2}, CartesianIndex{2}, Int}}()

        while !isempty(not_visited)

            heat, curr, dir, count = heappop!(not_visited)
            (curr == goal && count >= 4) && return heat
            ( curr, dir, count) ∈ visited && continue

            for d in next_ultra_coord(dir, count)
                next = curr + d
                !all((1,1) .<= next.I .<= (limit,limit)) && continue

                if d == dir
                    heappush!(not_visited, (heat + heat_dict[next], next, dir, count+1))
                else
                    heappush!(not_visited, (heat + heat_dict[next], next, d, 1))
                end

            end
    
            push!(visited, (curr, dir, count))
        end
    end

    function next_ultra_coord(d::CartesianIndex{2}, c::Int)
        if d.I == (0,0)
            return [CartesianIndex(1,0), CartesianIndex(0,1)]
        elseif c < 4
            return [d]
        elseif c > 9
            return [CartesianIndex(d[2], d[1]), CartesianIndex(-d[2], -d[1])]
        else
            return [CartesianIndex(d[2], d[1]), CartesianIndex(-d[2], -d[1]), d]
        end

    end


end 



