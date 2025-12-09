module Day09
    using ..AdventOfCode25

    """
        day09()

    Solves the two puzzles of day 09. 
    """

    function day09(input::String = readInput(09))

        tiles = Tuple{Int, Int}[]
        for l in split(input, "\n")
            push!(tiles, Tuple(parse.(Int, split(l, ","))))
        end

        s0, s1 = check_surface(tiles)

        return [s0, s1]
    end

    area(i::Int, j::Int, tiles::Vector{Tuple{Int, Int}}) = (abs(tiles[i][1] - tiles[j][1])+1) * (abs(tiles[i][2]-tiles[j][2])+1)

    function check_surface(tiles::Vector{Tuple{Int, Int}})

        s0 = 0
        s1 = 0 
        n = length(tiles)

        edges = zip(tiles, circshift(tiles, -1))

        for i in 1:n
            for j in i+1:n 

                curr_v = area(i, j, tiles)
                s0 = max(s0, curr_v)

                if curr_v > s1 
                    box_green(tiles[i], tiles[j], edges) && (s1 = curr_v)
                end

            end
        end
        
        return s0, s1
    end

    function box_green(a::Tuple{Int, Int}, b::Tuple{Int, Int}, edges::Base.Iterators.Zip{Tuple{Vector{Tuple{Int64, Int64}}, Vector{Tuple{Int64, Int64}}}})
        
        x_min = min(a[1], b[1])
        x_max = max(a[1], b[1])
        y_min = min(a[2], b[2])
        y_max = max(a[2], b[2])

        for ((e1, e2), (f1, f2)) in edges

            if !( max( e1, f1 ) <= x_min || x_max <= min( e1, f1) || max(e2, f2) <= y_min || y_max <= min(e2, f2) )
                return false
            end

        end

        return true
    end

end
