 
module Day05
    using ..AdventOfCode23

    """
        day05()

    Solves the two puzzles of day 05. 
    """

    function day05(input::String = readInput(05))
        blocks = split(input, "\n\n")
        n = length(blocks)

        r_s = r"(\d+)"
        r_t = r"(\d+) (\d+) (\d+)"

        seeds = Int[parse(Int, rm.match) for rm in eachmatch(r_s, blocks[1])]
        mappings = Dict{Int, Dict{UnitRange{Int}, UnitRange{Int}}}(i => Dict{UnitRange{Int}, UnitRange{Int}}() for i in 2:n)
        
        for i in 2:n

            for k in eachmatch(r_t, blocks[i])
                d, s, r = parse.(Int, k.captures)
                mappings[i][s:s+r-1] = d:d+r-1
            end

        end


        locations = Set{Int}()
        for location in seeds
            for k in 2:n
                location = apply_map(mappings[k], location)
            end
            push!(locations, location)
        end

        s0 = minimum(locations)

        locations = Set{UnitRange{Int}}[]
        for i in 1:2:length(seeds)-1
            location = Set{UnitRange{Int}}([seeds[i]:seeds[i]+seeds[i+1]])

            for k in 2:n
                location = apply_map(mappings[k], location)
            end
            push!(locations, location)
        end

        s1 = minimum(minimum.(x -> x.start, locations))
        
        return [s0, s1]
    end


    function apply_map(map::Dict{UnitRange{Int}, UnitRange{Int}}, number::Int)

        for (s,d) in map
            (number ∈ s) && (return d.start + (number - s.start))
        end

        return number
    end


    function apply_map(map::Dict{UnitRange{Int}, UnitRange{Int}}, numbers::Set{UnitRange{Int}})
        newset = Set{UnitRange{Int}}()

        while !isempty(numbers)
            inkeys = false
            ra = pop!(numbers)

            for (s, d) in map

                int = intersect(ra, s)
                if !isempty(int) 
                    inkeys = true
                    diff = d.start - s.start 

                    push!(newset, int.start+diff:int.stop+diff)
                    left = ra.start:int.start-1
                    !isempty(left) && push!(numbers, left)
                    right=int.stop+1:ra.stop
                    !isempty(right) && push!(numbers, right)
                    break

                end
                
            end

            !inkeys && push!(newset, ra)
        end

        return newset
    end


end 

