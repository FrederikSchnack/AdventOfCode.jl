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

            if is_valid(res, args)
                s0 += res
                s1 += res
            elseif is_valid(res, args, true)
                s1 += res
            end
           
        end

        return [s0, s1]
    end

    function |(l::Int, r::Int)
        return l * 10^(floor(Int,log10(r))+1)  + r
    end

    function is_valid(res::Int, args::Vector{Int}, concat::Bool=false)

        stack = [(args[1], args[2], 2, +),
                    (args[1], args[2], 2, *)]

        concat && push!(stack, (args[1], args[2], 2, |))

        while !isempty(stack)
            l, r, i, op = pop!(stack)
            ans = op(l, r)

            if res == ans && i == length(args)
                return true
            elseif res < ans || i == length(args)
                continue
            else
                push!(stack, (ans, args[i+1], i+1, +))
                push!(stack, (ans, args[i+1], i+1, *))
                concat && push!(stack, (ans, args[i+1], i+1, |))
            end
        end

        return false

    end
    
   
end 
