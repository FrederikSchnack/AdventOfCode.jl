module Day14

    using ..AdventOfCode22

    """
        day14()

    Solves the two puzzles of day 14. 
    """
    function day14(input::String = readInput(14))
        rock = Set{Tuple{Int, Int}}()
        sand = Set{Tuple{Int, Int}}()
        max_height = 0

        for line in split(input, "\n")
            pt = split(line, " -> ")
            pt = split.(pt, ",")
            for k in eachindex(pt)[1:end-1]
                a1, b1 = parse.(Int, pt[k])
                a2, b2 = parse.(Int, pt[k+1])

                max(b1, b2) > max_height && (max_height = max(b1, b2))

                for i in min(a1, a2):max(a1, a2)
                    for j in min(b1, b2):max(b1, b2)
                        push!(rock, (i,j))
                    end
                end
            end
        end

        while !((500, 0) ∈ sand)
            pos = (500, 0)

            while true 
                new_pos = check_fall(pos, rock, sand)
                pos == new_pos && break
                pos = new_pos
                pos[2] ≥ max_height && break
            end

            pos[2] ≥ max_height && break
            push!(sand, pos)
        end
        s0 = length(sand)

        while !((500, 0) ∈ sand)
            pos = (500, 0)

            while true 
                new_pos = check_fall(pos, rock, sand)
                pos == new_pos && break
                pos = new_pos
                pos[2] ≥ max_height+1 && break
            end

            push!(sand, pos)
        end
        s1 = length(sand)

        return [s0, s1]

    end

    function check_fall(pos::Tuple{Int, Int}, rock::Set{Tuple{Int, Int}}, sand::Set{Tuple{Int, Int}})
        if !(pos .+ (0,1) ∈ rock) && !(pos .+ (0,1) ∈ sand)
            return pos .+ (0,1)
        else
            if !(pos .+ (-1,1) ∈ rock) &&  !(pos .+ (-1,1) ∈ sand)
                return pos .+ (-1, 1)
            elseif !(pos .+ (1,1) ∈ rock) &&  !(pos .+ (1,1) ∈ sand)
                return pos .+ (1, 1)
            else
                return pos
            end
        end

    end

end # module