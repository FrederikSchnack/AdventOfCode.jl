module Day05
    using ..AdventOfCode24

    """
        day05()

    Solves the two puzzles of day 05. 
    """

    function day05(input::String = readInput(05))
        orders, updates = split(input, "\n\n")

        inv_order = Dict{Int, Set{Int}}()
        for m in eachmatch(r"(\d+)\|(\d+)", orders)
            d1, d2 = parse.(Int, m.captures)

            if d2 in keys(inv_order) 
                push!(inv_order[d2], d1) 
           else
               inv_order[d2] = Set(d1)
           end
        end

        s0 = 0
        s1 = 0
        for l in split(updates)
            u = parse.(Int, split(l, ","))
            m = Int((length(u)+1)/2)

            if check_next(u, inv_order) 
                s0 += u[m]
            else
                v = fix_order(u, inv_order, 1)
                s1 += v[m]
            end

        end
        

        return [s0, s1]
    end

    function check_next(u::Vector{Int}, inv_order::Dict{Int, Set{Int}})
        isempty(u) && return true

        if haskey(inv_order, u[1])
            !isempty( intersect(inv_order[u[1]], u)) && return false
        end

        return check_next(u[2:end], inv_order)
    end

    function fix_order(u::Vector{Int}, inv_order::Dict{Int, Set{Int}}, c::Int)
        (c == length(u)+1) && return u

        if haskey(inv_order, u[c])
            restr = inv_order[u[c]]

            for k in c+1:length(u)
                if u[k] ∈ restr
                    u[c], u[k] = u[k], u[c]
                    return fix_order(u, inv_order, c)
                end
            end

        end

        return fix_order(u, inv_order, c+1)
    end

end 

