
module Day24

using ..AdventOfCode22

"""
    day24()

Solves the two puzzles of day 24. 
"""
function day24(input::String = readInput(24))
    up = Set{CartesianIndex{2}}()
    dw = Set{CartesianIndex{2}}()
    ri = Set{CartesianIndex{2}}()
    le = Set{CartesianIndex{2}}()
    

    spl = split(input, "\n")
    n,m = length(spl)-2, length(spl[1])-2
    cycle = lcm(n,m)

    blocked = Dict{Int, Set{CartesianIndex{2}}}()
    free = Dict{Int, Set{CartesianIndex{2}}}()
    ground = Set([CartesianIndex(i, j) for i in 2:n+1 for j in 2:m+1])
    
    start = CartesianIndex(1, 2)
    final = CartesianIndex(n+2, m+1)
    push!(ground, start)
    push!(ground, final)

    for (i, s) in enumerate(spl)
        for j in eachindex(s)
            if s[j] == '^'
                push!(up, CartesianIndex{2}(i,j))
            elseif s[j] == 'v'
                push!(dw, CartesianIndex{2}(i,j))
            elseif s[j] == '>'
                push!(ri, CartesianIndex{2}(i,j))   
            elseif s[j] == '<'
                push!(le, CartesianIndex{2}(i,j))   
            end
        end
    end

    blocked[1] = union(up, dw, le, ri)
    fill_cycle!(blocked, 2, cycle+1, up, dw, ri, le, m, n)
    for i in 1:cycle
        free[i-1] = setdiff(ground, blocked[i])
    end


    s0 = run(start, final, free, cycle, 0)
    s01 = run(final, start, free, cycle, s0)
    s1 = s0 + s01 + run(start, final, free, cycle, s0+s01)

    return [s0, s1]
end

function fill_cycle!(blocked::Dict{Int, Set{CartesianIndex{2}}}, it::Int, cycle::Int,  up::Set{CartesianIndex{2}}, dw::Set{CartesianIndex{2}}, ri::Set{CartesianIndex{2}}, le::Set{CartesianIndex{2}}, m::Int, n::Int)

    it == cycle && return nothing

    up_ = Set{CartesianIndex{2}}()
    dw_ = Set{CartesianIndex{2}}()
    ri_ = Set{CartesianIndex{2}}()
    le_ = Set{CartesianIndex{2}}()

    for t in up 
        if t[1] == 2
            push!(up_, CartesianIndex(n + 1, t[2] ) )
        else
            push!(up_, CartesianIndex(t[1] - 1, t[2]) )
        end
    end

    for t in dw
        if t[1]  == n+1
            push!(dw_, CartesianIndex(2, t[2] ))
        else
            push!(dw_, CartesianIndex(t[1] + 1, t[2]))
        end
    end

    for t in le 
        if t[2]  == 2
            push!(le_, CartesianIndex(t[1], m + 1) )
        else
            push!(le_, CartesianIndex(t[1], t[2] - 1) )
        end
    end

    for t in ri 
        if t[2]  == m+1
            push!(ri_, CartesianIndex(t[1], 2 ))
        else
            push!(ri_, CartesianIndex(t[1], t[2] + 1))
        end
    end

    blocked[it] = union(up_, dw_, le_, ri_)

    fill_cycle!(blocked, it+1, cycle, up_, dw_, ri_, le_, m, n)

end
    
function run(start::CartesianIndex{2}, final::CartesianIndex{2}, free::Dict{Int, Set{CartesianIndex{2}}}, cycle::Int, time::Int)
    reached = Dict{Int, Set{CartesianIndex{2}}}()
    reached[time] = Set([start])
    t = time + 1
    while true
        (final in reached[t-1]) && return t - 1 - time

        reached[t] = Set{CartesianIndex{2}}()

        for p in reached[t-1]

            if p ∈ free[mod(t, cycle)]
                push!(reached[t], p)
            end
            
            if p + CartesianIndex(1,0) ∈ free[mod(t, cycle)]
                push!(reached[t], p + CartesianIndex(1,0) )
            end

            if p + CartesianIndex(-1,0) ∈ free[mod(t, cycle)]
                push!(reached[t], p + CartesianIndex(-1,0) )
            end
            
            if p + CartesianIndex(0, 1) ∈ free[mod(t, cycle)]
                push!(reached[t], p + CartesianIndex(0,1) )
            end

            if p + CartesianIndex(0, -1) ∈ free[mod(t, cycle)]
                push!(reached[t], p + CartesianIndex(0,-1) )
            end
        end

        t += 1
    end 

end

end # module