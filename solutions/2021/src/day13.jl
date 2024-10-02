module Day13
    using ..AdventOfCode21

    """
        day13()

    Solves the two puzzles of day 13. 
    """
    function day13(input::String = readInput(13))
    
        lines = split(input, "fold along ")
        x_max = 0
        y_max = 0
        pts = Set{Tuple{Int, Int}}()
        for c in split(lines[1], '\n')[1:end-2]
            x, y = parse.(Int, split(c, ','))   
            x > x_max && (x_max = x)
            y > y_max && (y_max = y)

            push!(pts, (x,y))
        end

        s0 = 0

        for (k, i) in enumerate(lines[2:end])
            i1 = split(i, '\n')[1]
            val = parse(Int, i1[3:end])
            for (x,y) in pts

                if i1[1] == 'x' && x > val
                    pop!(pts, (x,y))
                    push!(pts, (2*val - x , y))
                    x_max = val
                elseif i1[1] == 'y' && y > val
                    pop!(pts, (x,y))
                    push!(pts, (x, 2*val - y))
                    y_max = val
                end

                k == 1 && (s0 = length(pts))

            end
        end

        s1 = plot_points(pts, x_max, y_max)
        
        return [s0, s1]
    end

    function plot_points(pts::Set{Tuple{Int, Int}}, x_max::Int, y_max::Int)
        str = [[' ' for _ in 1:x_max-1] for _ in 1:y_max]

        for (x,y) in pts
            str[y+1][x+1] = '#'
        end

        return prod.(str)
    end


end 
