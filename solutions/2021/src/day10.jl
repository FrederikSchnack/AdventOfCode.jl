module Day10
    using ..AdventOfCode21

    """
        day10()

    Solves the two puzzles of day 10. 
    """
    function day10(input::String = readInput(10))

        flip = Dict('(' => ')',
                    '[' => ']',
                    '{' => '}',
                    '<' => '>')

        score_ill = Dict(')' => 3,
         ']'  => 57,
         '}'  => 1197,
         '>'  => 25137)

        score_comp = Dict(')' => 1,
         ']'  => 2,
         '}'  => 3,
         '>'  => 4)

        s0 = 0
        scores = Int[]
        
        for l in split(input, "\n")
            msg = Char[]
            ill = false

            for k in eachindex(l)
                c = l[k]
                if c ∈ keys(flip)
                    push!(msg, flip[c])
                else
                    if msg[end] == c 
                        pop!(msg)
                    else
                        s0 += score_ill[c]
                        ill = true
                        break
                    end
                end
            end

            !ill && push!(scores, calc_score(score_comp, msg[end:-1:1]))
        end

        s1 = sort(scores)[round(Int, length(scores)/2)]

        return [s0, s1]
    end

    function calc_score(score_comp::Dict{Char, Int}, comp::Vector{Char})

        score = 0
        for c in comp 
            score *= 5
            score += score_comp[c]
        end
        
        return score
    end
end 
