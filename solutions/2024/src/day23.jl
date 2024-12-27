module Day23
    using ..AdventOfCode24

    """
        day23()

    Solves the two puzzles of day 23. 
    """

    function day23(input::String = readInput(23))

        connections = Dict{String, Set{String}}()
        r = r"(\w+)\-(\w+)\n?"
        for l in eachmatch(r, input)
            c1, c2 = string.(l.captures)
            push!(get!(connections, c1, Set{String}()), c2)
            push!(get!(connections, c2, Set{String}()), c1)
        end

        ic = Set{NTuple{3, String}}()
        for l in eachmatch(r, input)
            c1, c2 = l.captures 
            for c in intersect(connections[c1], connections[c2])
                push!(ic, Tuple(sort([c1, c2, c])))
            end
        end

        s0 = filter!(t -> any(t[k][1] == 't' for k in 1:3), ic) |> length

        l = BronKerbosch(Set{String}(), Set(keys(connections)) , Set{String}(), connections) |> collect |> sort |> (x -> x .* ",") |> prod
        s1 = l[1:end-1]

        return [s0, s1]
    end

    function BronKerbosch(R::Set{String}, P::Set{String}, X::Set{String}, connections::Dict{String, Set{String}})::Set{String}
        
        (isempty(P) && isempty(X)) && (return R)
        
        res = Set{String}()

        for v in P
            nbs = get(connections, v, Set{String}())
            clique = BronKerbosch(R ∪ Set{String}([v]), P ∩ nbs, X ∩ nbs, connections)
            if length(clique) > length(res)
                res = clique
            end

            delete!(P, v)
            push!(X, v)
        end

        return res
    end
end 

