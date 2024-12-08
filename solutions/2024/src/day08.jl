module Day08
    using ..AdventOfCode24

    """
        day08()

    Solves the two puzzles of day 08. 
    """

    function day08(input::String = readInput(08))
        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]

        antennas = Dict{Char, Vector{CartesianIndex{2}}}()
        for k in findall(!=('.'), grid)
            a = grid[k]

            if haskey(antennas, a)
                push!(antennas[a], k)
            else
                antennas[a] = [k]
            end
        end

        nodes = Set{CartesianIndex{2}}()
        nodes1 = Set{CartesianIndex{2}}()

        for (_, pos) in antennas

            for p1 in pos
                for p2 in pos
                    p1 == p2 && continue
                    
                    diff = p1-p2

                    n1 = p1 + diff
                    n2 = p2 - diff
                    checkbounds(Bool, grid, n1) && push!(nodes, n1)
                    checkbounds(Bool, grid, n2) && push!(nodes, n2)


                    n1 = p1
                    n2 = p2
                    while checkbounds(Bool, grid, n1)
                        push!(nodes1, n1)
                        n1 += diff
                    end
                    while checkbounds(Bool, grid, n2)
                        push!(nodes1, n2)
                        n2 -= diff
                    end

                end
            end
        end

        s0 = length(nodes)
        s1 = length(nodes1)

        return [s0, s1]
    end


end 

