 
module Day03
    using ..AdventOfCode23

    """
        day03()

    Solves the two puzzles of day 03. 
    """

    function day03(input::String = readInput(03))
        
        s0 = 0
        s1 = 0

        lines= split(input, "\n")
        r_s = r"([^\d.\*])"
        r_d = r"(\d+)"
        r_g = r"(\*)"

        digits = Dict{Int, Vector{UnitRange{Int}}}()
        
        n = length(lines)
        m = length(lines[1])

        for (i, line) in enumerate(lines)
            digits[i] = findall(r_d, line)
        end

        for (i, line) in enumerate(lines)
            indices = findall(r_s, line)
            isnothing(indices) && continue

            for ind in indices
                                
                s0 += check_and_add(i, ind[1]+1, digits, lines)
                s0 += check_and_add(i, ind[1]-1, digits, lines)


                if i < n 
                    s0 += check_and_add(i+1, ind[1]-1, digits, lines)
                    s0 += check_and_add(i+1, ind[1], digits, lines)
                    s0 += check_and_add(i+1, ind[1]+1, digits, lines)
                end

                if i > 1
                    s0 += check_and_add(i-1, ind[1]-1, digits, lines)
                    s0 += check_and_add(i-1, ind[1], digits, lines)
                    s0 += check_and_add(i-1, ind[1]+1, digits, lines) 
                end

            end


            indices = findall(r_g, line)
            isnothing(indices) && continue

            for ind in indices
                count = []
                push!(count, check_and_add(i, ind[1]+1, digits, lines))
                push!(count, check_and_add(i, ind[1]-1, digits, lines))


                if i < n 
                    push!(count, check_and_add(i+1, ind[1]-1, digits, lines))
                    push!(count, check_and_add(i+1, ind[1], digits, lines))
                    push!(count, check_and_add(i+1, ind[1]+1, digits, lines))
                end

                if i > 1
                    push!(count, check_and_add(i-1, ind[1]-1, digits, lines))
                    push!(count, check_and_add(i-1, ind[1], digits, lines))
                    push!(count, check_and_add(i-1, ind[1]+1, digits, lines)) 
                end

                counter = findall( x-> x > 0, count)
                length(counter) == 2 && (s1 += prod(count[counter]))
                s0 += sum(count)

            end
        end

        return [s0, s1]
    end

    function check_and_add(i::Int, ind::Int, digits::Dict{Int, Vector{UnitRange{Int}}}, lines::Vector{SubString{String}})
        h = findfirst(x -> ind in x, digits[i])
        isnothing(h) && return 0
        
        return parse(Int, lines[i][popat!(digits[i],h)])
    end
end 