module Day07
    using ..AdventOfCode25
    using DataStructures

    """
        day07()

    Solves the two puzzles of day 07. 
    """

    function day07(input::String = readInput(07))

        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]
        
        S = findfirst(==('S'), grid)
        Q = OrderedDict{CartesianIndex{2}, Int}(S + CartesianIndex(1, 0) => 1) 

        s0 = 0
        s1 = 0
        while !isempty(Q)
            pos, t = popfirst!(Q)

            grid_value = get(grid, pos, 'x')

            if grid_value == '^'

                if get(Q, pos, 0) == 0
                    pos_left = pos +  CartesianIndex(1, -1)
                    Q[pos_left] = t + get!(Q,pos_left, 0)

                    pos_right = pos +  CartesianIndex(1, 1)
                    Q[pos_right] = t + get!(Q,pos_right, 0)

                    s0 += 1
                else 
                    Q[pos] = t+1
                end           

            elseif grid_value == '.'

                Q[pos + CartesianIndex(1, 0)] = t + get!(Q,pos + CartesianIndex(1, 0), 0)

            elseif grid_value == 'x'
                s1 += t

            end

        end

        return [s0, s1]
    end
end 

