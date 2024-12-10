module Day07
    using ..AdventOfCode24

    """
        day07()

    Solves the two puzzles of day 07. 
    """

    function day07(input::String = readInput(07))
        lines = split(input, "\n")

        s0 = 0
        s1 = 0

        for l in lines
            res = parse(Int, match(r"(\d+):", l).captures[1])
            args = [parse.(Int, m.captures[1]) for m in eachmatch(r"\s(\d+)", l)]

            if is_valid(res, args, 0, false)
                s0 += res
                s1 += res
            elseif is_valid(res, args, 0, true)
                s1 += res
            end
        end

        return [s0, s1]
    end

    function |(l::Int, r::Int)::Int
        return l * 10^(floor(Int,log10(r))+1)  + r
    end

    function is_valid(value::Int, ranges::Vector{Int}, acc::Int, concat::Bool)::Bool
        if length(ranges) == 0
            return acc == value
        end

        if acc > value
            return false
        end

        if concat
            return is_valid(value, ranges[2:end], acc + ranges[1], true) ||
                is_valid(value, ranges[2:end], acc * ranges[1], true) ||
                is_valid(value, ranges[2:end], |(acc, ranges[1]), true)
        else
            return is_valid(value, ranges[2:end], acc + ranges[1], false) ||
                    is_valid(value, ranges[2:end], acc * ranges[1], false)
        end
    end
    
    
   
end 
