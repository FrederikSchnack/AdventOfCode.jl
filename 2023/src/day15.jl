module Day15
    using ..AdventOfCode23

    """
        day15()

    Solves the two puzzles of day 15. 
    """
    mutable struct Lens
        label::String
        focal::Int
    end

    const Box = Vector{Lens}

    function day15(input::String = readInput(15))
        shelf = Dict{Int, Box}(i => Lens[] for i in 1:256)
        s0 = 0
        rw = r"(\w+)"
        for s in split(input, ',')

            s0 += ha(s)

            label = s[findfirst(rw, s)]
            i_shelf = ha(label) + 1

            if s[end] == '-'

                j_box = findfirst(x -> x.label == label, shelf[i_shelf])
                !isnothing(j_box) && deleteat!(shelf[i_shelf], j_box)

            elseif s[end-1] == '='

                focal = parse(Int, s[end])
                j_box = findfirst(x -> x.label == label, shelf[i_shelf])

                if isnothing(j_box) 
                    push!(shelf[i_shelf], Lens(label, focal))
                else
                    shelf[i_shelf][j_box].focal = focal
                end

            end
        end

        s1 = get_score(shelf)
        
        return [s0, s1]
    end

    function ha(s::AbstractString)
        v = 0

        for c in s 
            v += Int(c)
            v *= 17
            v %= 256
        end

        return v 
    end

    function get_score(shelf::Dict{Int, Box})
        s1 = 0
        for (i,v) in shelf
            for (j,box) in enumerate(v)
                s1 += i * j * box.focal
            end
        end

        return s1
    end
end 

