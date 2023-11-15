module Day09

    using ..AdventOfCode22

    """
        day09()

    Solves the two puzzles of day 9. 
    """
    function day09(input::String = readInput(9))
        r0 = Rope(ntuple(_ -> Knot(0,0), 2)) 
        r1 = Rope(ntuple(_ -> Knot(0,0), 10))

        visited0 = Set{Tuple{Int, Int}}()
        visited1 = Set{Tuple{Int, Int}}()

        for l in split(input, "\n")
            dir = l[1:1]
            len = parse(Int, l[3:end])
            move!(r0, visited0, dir, len)
            move!(r1, visited1, dir, len)
        end

        s0 = length(visited0)
        s1 = length(visited1)

        return [s0, s1]
    end 

    mutable struct Knot
        x::Int
        y::Int
    end

    mutable struct Rope{N}
        knots::NTuple{N, Knot}
    end

    function coord(s::Knot)::Tuple{Int, Int}
        return (s.x, s.y)
    end

    function move!(r::Rope, visited::Set{Tuple{Int, Int}}, dir::AbstractString, len::Int)

            for _ in 1:len
                one_step!(r.knots[1], r.knots[2], dir)

                for i in eachindex(r.knots)[2:end]
                    one_step!(r.knots[i-1], r.knots[i], dir, true)
                end

                push!(visited, coord(r.knots[end]))
            end
    end

    function one_step!(h::Knot, t::Knot, dir::AbstractString, follow::Bool=false)
        if follow
        elseif dir == "R"
            h.x += 1
        elseif dir == "L"
            h.x -= 1
        elseif dir == "U"
            h.y += 1
        elseif dir == "D"
            h.y -= 1
        end

        if abs(h.x - t.x) > 1 && abs(h.y - t.y) == 1
            t.x += sign(h.x - t.x)
            t.y = h.y 
        elseif abs(h.x - t.x) == 1 && abs(h.y - t.y) > 1
            t.x = h.x 
            t.y += sign(h.y - t.y)
        else
            abs(h.x - t.x) > 1 && (t.x += sign(h.x - t.x))
            abs(h.y - t.y) > 1 && (t.y += sign(h.y - t.y))
        end
    end
end # module