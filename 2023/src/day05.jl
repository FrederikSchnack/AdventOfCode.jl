module Day05
    using ..AdventOfCode23

    """
        day05()

    Solves the two puzzles of day 05. 
    """
    struct Mapping
        src::UnitRange{Int}
        dst::UnitRange{Int}
    end

    function Mapping(d::Int, s::Int, r::Int)
        return Mapping(s:s+r-1, d:d+r-1)
    end

    function(f::Mapping)(i::Int)
        (i ∈ f.src) && (return i + f.dst.start - f.src.start)
        nothing
    end

    function (f::Mapping)(ur::UnitRange{Int})
        start, stop = f.src.start, f.src.stop

        if ur.start < start 
            left = ur.start:min(ur.stop, start-1)
        else
            left = stop:start
        end

        if (start <= ur.stop) & (stop >= ur.start)
            mapped = f(max(ur.start, start)):f(min(ur.stop, stop))
        else
            mapped = stop:start
        end

        if stop < ur.stop
            right = max(ur.start, stop+1):ur.stop
        else
            right = stop:start
        end

        return (left, mapped, right)
    end

    struct Mappings
        maps::Set{Mapping}
    end

    function (f::Mappings)(i::Int)
        for m in f.maps
            dst = m(i)
            !isnothing(dst) && return dst
        end
        return i
    end

    function (f::Mappings)(ur::UnitRange{Int})
        result = UnitRange{Int}[]
        Q = UnitRange{Int}[ur]

        for m in f.maps
            for _ in eachindex(Q)

                q = pop!(Q)
                left, mapped, right = m(q)
                !isempty(left) && push!(Q, left)
                !isempty(mapped) && push!(result, mapped)
                !isempty(right) && push!(Q, right)

            end

        end

        append!(result, Q)

        return result
    end


    function day05(input::String = readInput(05))
        blocks = split(input, "\n\n")

        r_s = r"(\d+)"
        r_t = r"(\d+) (\d+) (\d+)"

        seeds = Int[parse(Int, rm.match) for rm in eachmatch(r_s, blocks[1])]
        mappings = Mappings[]
        
        for b in blocks[2:end]
            push!(mappings, Mappings( Set{Mapping}([Mapping(parse.(Int, k.captures)...) for k in eachmatch(r_t, b)])))
        end

        locations = Set{Int}()
        for location in seeds
            for m in mappings
                location = m(location)
            end
            push!(locations, location)
        end

        s0 = minimum(locations)

        locations = UnitRange{Int}[]
        for i in 1:2:length(seeds)-1
            location = UnitRange{Int}[seeds[i]:seeds[i]+seeds[i+1]]

            for m in mappings
                next = UnitRange{Int}[]
                
                for loc in location 
                    append!(next, m(loc))
                end
                location = next
            end

            append!(locations, location)
        end

        s1 = minimum(x -> x.start, locations)
        
        return [s0, s1]
    end


end 

