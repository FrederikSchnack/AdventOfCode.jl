module Day02
    using ..AdventOfCode24

    """
        day02()

    Solves the two puzzles of day 02. 
    """

    function day02(input::String = readInput(02))
        s0 = 0
        s1 = 0

        for l in split(input, "\n")
           
            n = parse.(Int, split(l))

            if is_safe(n)
                s0 += 1 
                s1 += 1
            else

                for k in eachindex(n)
                    if is_safe(deleteat!(copy(n), k))
                        s1 += 1
                        break
                    end
                end

            end

        end

        return [s0, s1]
    end

    function is_safe(n::Vector{Int})
        sgn = sign(n[2] - n[1]) 

        for i in 2:lastindex(n)
            !(0 < sgn*(n[i] - n[i-1]) <= 3 ) && return false
        end

        return true
    end


end