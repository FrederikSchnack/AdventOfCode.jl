
module Day23

using ..AdventOfCode22

"""
    day23()

Solves the two puzzles of day 23. 
"""
function day23(input::String = readInput(23))
    pos = Set{CartesianIndex{2}}()
    prop = Dict{CartesianIndex{2}, CartesianIndex{2}}() 

    for (i, s) in enumerate(split(input, "\n"))
        for j in eachindex(s)
            if s[j] == '#'
                push!(pos, CartesianIndex(i,j))
            end
        end
    end


    order = [1,2,3,4]
    for _ in 1:10
        propose_pos!(pos, prop, order)
        change_pos!(pos, prop)
        push!(order, popfirst!(order))
    end
    s0 = get_area(pos) - length(pos)

    it = 10
    while true
        it += 1 
        propose_pos!(pos, prop, order)
        isempty(prop) && break
        change_pos!(pos, prop)
        push!(order, popfirst!(order))
    end
    s1 = it

    return [s0, s1]
end

const dir = [[CartesianIndex(-1,0), CartesianIndex(-1,-1),  CartesianIndex(-1,1)], 
            [CartesianIndex(1,0),   CartesianIndex(1,-1),   CartesianIndex(1,1)], 
            [CartesianIndex(0,-1), CartesianIndex(-1,-1),  CartesianIndex(1,-1)], 
            [CartesianIndex(0,1), CartesianIndex(-1,1),  CartesianIndex(1,1)]]



function propose_pos!(pos::Set{CartesianIndex{2}}, prop::Dict{CartesianIndex{2}, CartesianIndex{2}}, order::Vector{Int})

    for p in pos

        !wants_to_move(pos, p) && continue

        for k in order
            if dir[k][1] + p ∉ pos && dir[k][2] + p ∉ pos && dir[k][3] + p ∉ pos
                prop[p] = dir[k][1] + p
                break
            end
        end
    end
end

function wants_to_move(s::Set{CartesianIndex{2}}, c::CartesianIndex{2})
    c + CartesianIndex(-1, -1) ∈ s && return true
    c + CartesianIndex(-1, 0) ∈ s && return true
    c + CartesianIndex(-1, 1) ∈ s && return true
    c + CartesianIndex(0, -1) ∈ s && return true
    c + CartesianIndex(0, 1) ∈ s && return true
    c + CartesianIndex(1, -1) ∈ s && return true
    c + CartesianIndex(1, 0) ∈ s && return true
    c + CartesianIndex(1, 1) ∈ s && return true
    return false
end


function nonunique(prop::Dict{CartesianIndex{2}, CartesianIndex{2}}) 
    dup = Set{CartesianIndex{2}}()
    p = Set{CartesianIndex{2}}()
    for v in values(prop)
        if v in p
            push!(dup, v)
        elseif !isnothing(v)
            push!(p, v)
        end
    end

    return dup
end


function change_pos!(pos::Set{CartesianIndex{2}}, prop::Dict{CartesianIndex{2}, CartesianIndex{2}})
    not_unique = nonunique(prop)
    for (i, p) in prop
        if  !(p in not_unique)
            push!(pos, p)
            delete!(pos, i)
        end
        
        delete!(prop, i)
    end
end


function get_area(pos::Set{CartesianIndex{2}})
    xmin, xmax, ymin, ymax = (1,1,1,1)

    for p in pos
        x,y = p.I
        (x > xmax) && (xmax = x)
        (x < xmin) && (xmin = x)
        (y > ymax) && (ymax = y)
        (y < ymin) && (ymin = y)
    end

    return (xmax-xmin+1)*(ymax-ymin+1)
end


end # module