module Day16

    using ..AdventOfCode22

    """
        day16()

    Solves the two puzzles of day 16. 
    """
    function day16(input::String = readInput(16))
        regex = r"Valve (\w+) has flow rate=(\d+); tunnels* leads* to valves* (\w+\,*.+)*"
        
        valves = Dict{String, Valve}()
        
        for l in split(input, "\n")
            room, flow, tunnel = match(regex, l).captures
            room = string(room)
            flow = parse(Int, flow)
            tunnel = string.(split(tunnel, ", "))
            valves[room] = Valve(flow, Dict(j => 1 for j in tunnel))
        end

        for k in valves
        for i in valves
        for j in valves
            if i!=j && j!=k && k!= i && k[1] ∈ keys(i[2].next) && j[1] ∈ keys(k[2].next)
                t = i[2].next[k[1]] + k[2].next[j[1]]
                j[1] ∈ keys(i[2].next) ? t_ = i[2].next[j[1]] : t_ = 999999
                t_ > t && (i[2].next[j[1]] = t)
            end
        end
        end
        end
    


        valves = Dict( i => Valve(v.flow, Dict(j => w for (j,w) in v.next if valves[j].flow !== 0)) for (i, v) in valves if v.flow !== 0 || i == "AA")

        global s0 = 0
        dfs(0, Set{String}(), 0, "AA", valves)
    
        scores = Dict{Int, Set{String}}()
        dfs(0, Set{String}(), 0, "AA", valves, scores)

        s1 = 0
        for (i,v) in scores
            for (j, w) in scores
                isempty(intersect(v, w)) && (s1 = max(s1, i+j))
            end
        end

        return [s0, s1]
    end


    struct Valve
        flow::Int
        next::Dict{AbstractString, Int}
    end

    function dfs(rel::Int, opened::Set{String}, t::Int, loc::String, valves::Dict{String, Valve})
        global s0 = max(s0, rel)
        for (a, d) in valves[loc].next
            if !(a ∈ opened) && t+d+1 < 30
                dfs(rel + (30-t-d-1)*valves[a].flow, union(opened, Set([a])), t+d+1, a, valves)
            end
        end
    end

    function dfs(rel::Int, opened::Set{String}, t::Int, loc::String, valves::Dict{String, Valve}, scores::Dict{Int, Set{String}})
        for (a, d) in valves[loc].next
            if !(a ∈ opened) && t+d+1 < 26
                dfs(rel + (26-t-d-1)*valves[a].flow, union(opened, Set([a])), t+d+1, a, valves, scores)
            end
        end

        scores[rel] = opened
    end

end # module