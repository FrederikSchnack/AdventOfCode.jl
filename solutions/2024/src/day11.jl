module Day11
    using ..AdventOfCode24

    """
        day11()

    Solves the two puzzles of day 11. 
    """


    function day11(input::String = readInput(11))
        stones = Dict(parse(Int, x) => 1 for x in split(input))

        stones = blink(stones, 25)
        s0 = sum(v for v in values(stones))

        stones = blink(stones, 50)
        s1 = sum(v for v in values(stones))

        return [s0, s1]
    end

    function blink(stones::Dict{Int, Int}, m::Int)
        new_stones = Dict{Int, Int}()

        for _ in 1:m
            apply_rules!(stones, new_stones)
            stones, new_stones = new_stones, stones
        end

        return stones
    end

    function apply_rules!(old_stones::Dict{Int, Int}, new_stones::Dict{Int, Int})

        for (x, v) in old_stones
            old_stones[x] -= v

            if x == 0
                new_stones[1] = get!(new_stones, 1, 0) + v

            elseif iseven( floor(Int, log10(x)) + 1 )
                n = floor(Int, log10(x)) + 1
                fac = 10^Int(n/2)
                first = div(x, fac)
                last = x - first * fac

                new_stones[first] = get!(new_stones, first, 0) + v
                new_stones[last] = get!(new_stones, last, 0) + v
                
            else
                y = 2024 * x
                new_stones[y] = get!(new_stones, y, 0) + v

            end
        end
        

    end

end 

