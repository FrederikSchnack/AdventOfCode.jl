module Day08
    using ..AdventOfCode25
    using DataStructures

    """
        day08()

    Solves the two puzzles of day 08. 
    """

    function day08(input::String = readInput(08))
        
        coords = Tuple{Int, Int, Int}[]
        for l in split(input, "\n")
            push!(coords, Tuple(parse.(Int, split(l, ","))))
        end

        edges = get_weighted_edges(coords)
        Q = IntDisjointSet(length(coords))


        for _ in 1:1000
            (_, a, b) = heappop!(edges)
            union!(Q, a, b)
        end

        c = counter(Int)
        for i in 1:length(coords)
            c[find_root!(Q, i)] +=1
        end

        s0 = c |> values |> collect |> sort! |> x -> prod(x[end-2:end])

        while num_groups(Q) > 1
            (_, a, b) = heappop!(edges)
            union!(Q, a, b)
        end

        s1 = coords[a][1] * coords[b][1]

        return [s0, s1]
    end


    function dist(a::Tuple{Int, Int, Int}, b::Tuple{Int, Int, Int})
        return (a[1] - b[1])^2 + (a[2] - b[2])^2 + (a[3] - b[3])^2
    end

    function get_weighted_edges(coords::Vector{Tuple{Int, Int, Int}})
        edges = Tuple{Int, Int, Int}[]
        n = length(coords)

        for i in 1:n
            for j in i+1:n
                d = dist(coords[i], coords[j])
                push!(edges, (d, i, j))
            end
        end

        heapify!(edges)

        return edges
    end
end
