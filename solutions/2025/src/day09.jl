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

        for i in 1:n
            for j in i+1:n 

                curr_v = area(i, j, tiles)
                s0 = max(s0, curr_v)

                if curr_v > s1 
                    box_green(i, j, tiles) && (s1 = curr_v)

                end

            end
        end
        
        return s0, s1
    end

    function box_green(i::Int, j::Int, tiles::Vector{Tuple{Int64, Int64}})
        
        x_min, x_max = min(tiles[i][1], tiles[j][1]), max(tiles[i][1], tiles[j][1])
        y_min, y_max = min(tiles[i][2], tiles[j][2]), max(tiles[i][2], tiles[j][2])

        n = length(tiles)

        for i in 1:n-1

            ex_min, ex_max = min(tiles[i][1], tiles[i+1][1]), max(tiles[i][1], tiles[i+1][1])
            ey_min, ey_max = min(tiles[i][2], tiles[i+1][2]), max(tiles[i][2], tiles[i+1][2])

            if !(ex_max <= x_min || x_max <= ex_min || ey_min <= y_min || y_max <= ey_max)
                return false
            end

        end

        ex_min, ex_max = min(tiles[n][1], tiles[1][1]), max(tiles[n][1], tiles[1][1])
        ey_min, ey_max = min(tiles[n][2], tiles[1][2]), max(tiles[n][2], tiles[1][2])

        if !(ex_max <= x_min || x_max <= ex_min || ey_min <= y_min || y_max <= ey_max)
            return false
        end

        return true
    end

end
