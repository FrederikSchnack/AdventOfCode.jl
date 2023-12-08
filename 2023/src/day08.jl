module Day08
    using ..AdventOfCode23

    """
        day08()

    Solves the two puzzles of day 08. 
    """

    function day08(input::String = readInput(08))
        lines = split(input, "\n")

        inst = string(lines[1])

        re = r"(\w{3}) = \((\w{3}), (\w{3})\)"
        nodes = Dict{String, Tuple{String, String}}()
        curr = Set{String}()
        steps = Dict{String, Int}()

        for node in lines[3:end]
            n, l, r = string.(match(re, node).captures)
            nodes[n] = (l, r)
            if n[3] == 'A'
                push!(curr, n)
            end
        end

        for node in curr
            solve!(node, inst, nodes, steps)
        end

        s0 = steps["AAA"]
        s1 = lcm(collect(values(steps)))

        return [s0, s1]
    end

    function solve!(node::String, inst::String, nodes::Dict{String, Tuple{String, String}}, steps::Dict{String, Int})
        s = 0
        len = length(inst)

        curr = node
        while curr[3] != 'Z'

            if @inbounds inst[s%len + 1] == 'L'
                curr = @inbounds nodes[curr][1]
            else 
                curr = @inbounds nodes[curr][2]
            end

            s += 1
        end

        @inbounds steps[node] = s 
    end

end 

