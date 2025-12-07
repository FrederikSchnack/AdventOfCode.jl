module Day06
    using ..AdventOfCode25

    """
        day06()

    Solves the two puzzles of day 06. 
    """

    function day06(input::String = readInput(06))
        lines = split(input, "\n")
        instructions = [a.captures[1] for a in eachmatch(r"(\*|\+)", lines[end])]

        s0 = 0
        s1 = 0

        c = 1
        d0 = String["" for _ in 1:length(lines)-1]
        d1 = Vector{Int}()
        for j in 1:length(lines[1])
            v = ""

            for i in 1:length(lines)-1
                v *= lines[i][j]
                d0[i] *= lines[i][j]
            end
            
            if isempty(strip(v)) || j == length(lines[1])
                
                j == length(lines[1]) && push!(d1, parse(Int, v))
    
                s0 += op2func[instructions[c]](parse.(Int, d0))
                s1 += op2func[instructions[c]](d1)

                c += 1
                d0 .^= 0
                empty!(d1)
                continue
            end

            push!(d1, parse(Int, v))
        end

        return [s0, s1]
    end

    const op2func = Dict("*" => prod, "+" => sum)
end 

