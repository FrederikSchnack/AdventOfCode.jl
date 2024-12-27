module Day24
    using ..AdventOfCode24

    """
        day24()

    Solves the two puzzles of day 24. 
    """

    function day24(input::String = readInput(24))
        initial, ops = split(input, "\n\n")
        
        r1 = r"(\w+)\: (\d)\n?"
        states = Dict{String, Bool}( string(k.captures[1]) => parse(Bool, k.captures[2]) for k in eachmatch(r1, initial))

        r2 = r"(\w+) (\w+) (\w+) \-\> (\w+)\n?"
        op = [Tuple(string.(k.captures)) for k in eachmatch(r2, ops)]
        k = 0
        
        or = Dict{NTuple{3, String}, String}()
        invor = Dict{String, NTuple{3, String}}()
        while !isempty(op) 
            
            k1, o, k2, t = popfirst!(op)
            !(haskey(states, k1) && haskey(states, k2)) && (push!(op, (k1, o, k2, t)); continue)

            states[t] = apply(states[k1], o, states[k2])
            or[(k1, o, k2)] = t
            invor[t] = (k1, o, k2)

            k += 1
        end

        s0 = parse_state("z", states)

        s1 = []
        for ((k1, o, k2), t) in or

            if t[1] == 'z' 
                if o != "XOR" && t[2:3] != "45"
                    push!(s1, t)
                    continue
                end

            elseif !(k1[1] in "xy" && k2[1] in "xy") &&  o == "XOR"
                push!(s1, t)
                continue
            end

            (k1[2:3] != "00" && k2[2:3] != "00" ) && continue

            if o == "XOR" && k1[1] in "xy" && k2[1] in "xy" 
                
                faulty = true
                for ((kk1, oo, kk2), _) in or

                    if t == kk1 || t == kk2
                        oo == "XOR" &&(faulty = false; break)
                    end
                end

                faulty && push!(s1, t)
            end

            if o == "AND"  
                
                faulty = true
                for ((kk1, oo, kk2), _) in or
                    if t == kk1 || t == kk2
                        oo == "OR" && (faulty = false; break)
                    end
                end

                faulty && push!(s1, t)
            end

        end

        s1 = prod(sort(s1) .* ',')[1:end-1]

        return [s0, s1]

    end

    function parse_state(n::String, states::Dict{String, Bool})
        s = 0
        
        i1 = 0
        i2 = 0
        while haskey(states, "$n$i1$i2")
            i = i1 * 10 + i2
            s += states["$n$i1$i2"] * 2^i
            i+=1
            i2 = i % 10 
            i1 = i ÷ 10
        end

        return s
    end

    
    function apply(v1::Bool, o::String, v2::Bool)::Bool
        if o == "AND"
            return v1 & v2
        elseif o == "OR"
            return v1 | v2
        elseif o == "XOR"
            return v1 ⊻ v2
        end
    end

end 

