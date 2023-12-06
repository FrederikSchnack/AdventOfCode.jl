 
module Day04
    using ..AdventOfCode23

    """
        day04()

    Solves the two puzzles of day 04. 
    """

    function day04(input::String = readInput(04))

        s0 = 0
        
        lines = split(input, "\n")        
        n = length(lines)
        cards = Dict{Int, Int}(i => 1 for i in 1:n)
        winning = Set{Int}() 
        numbers = Set{Int}()

        r = r"(\d+)"
        vert = findfirst(r"\|", lines[1])[1]
        ddot = findfirst(r"\:", lines[1])[1]


        for (i, l) in enumerate(lines)

            for j in findall(r, l)
                j[1] < ddot && continue
                
                if j[1] < vert  
                    push!(winning, parse(Int, l[j])) 
                else 
                    push!(numbers, parse(Int, l[j])) 
                end
            end

            k = length(intersect!(numbers, winning))

            if (k > 0) 
                s0 += 2^(k-1)

                for j in 1:k
                    ((i + j) > n) && break
                    cards[i+j] += cards[i]
                end
            end

            empty!(winning)
            empty!(numbers)
        end

        s1 = sum(values(cards))

        return [s0, s1]
    end
end 

