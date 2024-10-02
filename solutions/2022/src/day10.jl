module Day10

    using ..AdventOfCode22

    """
        day10()

    Solves the two puzzles of day 10. 
    """
    function day10(input::String = readInput(10))
        cycle::Int = 1
        X::Int = 1
        stamps = Int[20, 60, 100, 140, 180, 220]
        vals = Int[]
        lines = Char['.' for _ in 1:6*40]
        draw_pixel!(lines, cycle, X)

        for l in split(input, "\n")
            if l == "noop"
                cycle += 1
                draw_pixel!(lines, cycle, X)
            else 
                cycle += 1
                draw_pixel!(lines, cycle, X)

                cycle ∈ stamps && push!(vals, X*cycle)
               
                X += parse(Int, l[6:end]) 
                cycle += 1
                draw_pixel!(lines, cycle, X)
            end

            cycle ∈ stamps && push!(vals, X*cycle)
        end

        s0 = sum(vals)
        s1 = prod([prod(lines[1+(j-1)*40:j*40])*"\n" for j in 1:5]) # = PLPAFBCL
        return [s0, s1]
    end

    function draw_pixel!(lines::Vector{Char}, cycle::Int, X::Int)
        if mod(cycle, 40) ∈ X:X+2
            lines[cycle] = '#'
        end
    end

end # module