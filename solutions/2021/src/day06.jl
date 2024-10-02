module Day06
    using ..AdventOfCode21

    """
        day06()

    Solves the two puzzles of day 6. 
    """
    function day06(input::String = readInput(6))
        
        lanternfish = Dict{Int, Int}(i => 0 for i in 0:8)

        for x in split(input, ",")
            lanternfish[parse(Int, x)] += 1
        end

        for _ in 1:80
            update_lanternfish!(lanternfish)
        end

        s0 = sum(values(lanternfish))

        for _ in 81:256
            update_lanternfish!(lanternfish)
        end

        s1 = sum(values(lanternfish))

        return [s0, s1]
    end

    function update_lanternfish!(lanternfish::Dict{Int, Int})
        x_0 = lanternfish[0]
        for x in 1:8
            lanternfish[x-1] = lanternfish[x]
        end

        lanternfish[6] += x_0
        lanternfish[8] = x_0
    end
end 
