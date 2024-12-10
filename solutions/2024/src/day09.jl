module Day09
    using ..AdventOfCode24

    """
        day09()

    Solves the two puzzles of day 09. 
    """

    function day09(input::String = readInput(09))
        disk =  [parse(Int, m) for m in input]

        maxid = floor(Int, length(disk)/2)
        ids = Dict{Int, Int}(k-1 => m for (k,m) in enumerate(disk[1:2:end]) )
        gaps = Dict{Int, Vector{Int}}( k-1 => [m] for (k,m) in enumerate(disk[2:2:end]) )
        gaps[maxid] = [0]

        ids1 = deepcopy(ids)
        gaps1 = deepcopy(gaps)

        d = Int[]
        d1 = Int[]
        for k in 0:maxid
           fill_id!(d, ids, k)
           fill_id!(d1, ids1, k)

            fill_gaps0!(d, ids, gaps, k, maxid)
            fill_gaps1!(d1, ids1, gaps1, k, maxid)
        end 
        
        s0 = checksum(d)
        s1 = checksum(d1)

        return [s0,s1]
    end

    function checksum(d::Vector{Int})
        s = 0
        for (k,m) in enumerate(d)
            (m >= 0) && (s += (k-1) * m)
        end

        return s
    end

    function fill_id!(d::Vector{Int}, ids::Dict{Int, Int}, k::Int)
        
        !haskey(ids, k) && return

        for _ in 1:ids[k]
            push!(d, k)
        end

        delete!(ids, k)

    end

    function fill_gaps1!(d::Vector{Int}, ids::Dict{Int, Int}, gaps::Dict{Int, Vector{Int}}, k::Int, maxid::Int)

        for g in gaps[k]
            l = g
            
            while true
                l == 0 && break
                l_old = l

                for k in maxid:-1:1
                    !haskey(ids, k) && continue

                    if l >= ids[k]

                        l = l-ids[k]
                        
                        for _ in 1:ids[k]
                            push!(d, k)
                        end

                        pushfirst!(gaps[k], ids[k])

                        delete!(ids, k)

                        break
                    end

                end

                if l == l_old 
                    for _ in 1:l
                        push!(d, -1)
                    end

                    break
                end
            end

        end


    end

    function fill_gaps0!(d::Vector{Int}, ids::Dict{Int, Int}, gaps::Dict{Int, Vector{Int}}, k::Int, maxid::Int)

        for g in gaps[k]
            l = g  
            while l > 0 && !isempty(ids)
                
                for k in maxid:-1:1
                    !haskey(ids, k) && continue

                    if l >= ids[k]

                        l = l-ids[k]
                        
                        for _ in 1:ids[k]
                            push!(d, k)
                        end

                        delete!(ids, k)

                        break
                    else
                        
                        for _ in 1:l
                            push!(d, k)
                        end
                        
                        ids[k] -= l                        
                        l = 0
                        break
                    end
                end
        
            end

        end

    end

end 

