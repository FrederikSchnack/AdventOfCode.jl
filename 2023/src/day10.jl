module Day10
    using ..AdventOfCode23

    """
        day10()

    Solves the two puzzles of day 10. 
    """
    
    const directions = Dict(
        '|' => (CartesianIndex(0, -1), CartesianIndex(0, 1)),
        '-' => (CartesianIndex(-1, 0), CartesianIndex(1, 0)),
        'L' => (CartesianIndex(0, -1), CartesianIndex(1, 0)),
        'J' => (CartesianIndex(0, -1), CartesianIndex(-1, 0)),
        '7' => (CartesianIndex(0, 1), CartesianIndex(-1, 0)),
        'F' => (CartesianIndex(0, 1), CartesianIndex(1, 0)),
        'S' => (CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(-1, 0))
        )

    function day10(input::String = readInput(10))
        lines = split(input, "\n")

        ind = findfirst(x ->  x == 'S', input)
        n = length(lines[1])
        S = CartesianIndex(rem(ind, n+1), (1 + div(ind, n+1)))

        pos = [S, S]
        hist = copy(pos)

        s0 = 0
        s1 = 0 

        while true
            no_step = false
            s0 += 1

            for d in 1:2
                for dir in directions[lines[pos[d][2]][pos[d][1]]]
                    next = pos[d] + dir

                    if lines[next[2]][next[1]] in keys(directions) && hist[d] !== next && pos[1] !== next && pos[2] !== next

                        if d == 1
                            s1 -= 1/2 * (next[1] + pos[d][1]) * (next[2] - pos[d][2])
                        else
                            s1 += 1/2 * (next[1] + pos[d][1]) * (next[2] - pos[d][2])
                        end

                        hist[d] = pos[d]
                        pos[d] = next
                        
                        no_step = false
                        break
                    else

                        no_step = true
                    end

                end

                
            end

            if no_step
                s1 -= 1/2 * (pos[2][1] + pos[1][1]) * (pos[2][2] - pos[1][2])
                break
            end
        end

        s1 = round(Int, abs(s1) - s0 + 1)

        return [s0, s1]
    end

end
