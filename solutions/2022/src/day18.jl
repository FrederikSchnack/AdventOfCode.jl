module Day18

    using ..AdventOfCode22

    """
        day18()

    Solves the two puzzles of day 18. 
    """
    function day18(input::String = readInput(18))
        lava = Set{Tuple{Int, Int, Int}}()
        for k in split(input, "\n")
            push!(lava, Tuple(parse.(Int, split(k, ','))))
        end
        nbhs = ((1, 0, 0), (-1, 0, 0), (0, 1, 0), (0,-1, 0), (0,0,1), (0,0,-1))

        s0 = 0
        for ind in lava
            for nbh in nbhs
                !(ind .+ nbh ∈ lava) && (s0 += 1)
            end
        end
        out_cube = Set{Tuple{Int, Int, Int}}()
        x = (0,0)
        y = (0,0)
        z = (0,0)

        for ind in lava
            x = (min(x[1], ind[1]-1), max(x[2], ind[1]+1))
            y = (min(y[1], ind[2]-1), max(y[2], ind[2]+1))
            z = (min(z[1], ind[3]-1), max(z[2], ind[3]+1))
        end
        for xx in x[1]:1:x[2]
            for yy in y[1]:1:y[2]
                for zz in z[1]:1:z[2]
                    push!(out_cube, (xx, yy, zz))
                end
            end
        end

        ocube = (x[1], y[1], z[1])
        out_air = Set{Tuple{Int, Int, Int}}([ocube])
        Q = Tuple{Int, Int, Int}[ocube]
        for a in Q
            for nbh in nbhs
                b = a .+ nbh
                if b ∈ out_cube && !(b ∈ lava) && !(b ∈ out_air)
                    push!(out_air, b)
                    push!(Q, b)
                end
            end
        end

        outside = union(out_air, lava)
        in_air  = setdiff(out_cube, outside)

        s1 = 0
        for ind in lava
            for nbh in nbhs
                ind .+ nbh ∈ in_air && (s1 += 1)
            end
        end

        s1 = s0 - s1

        return [s0, s1]
    end
     
end # module