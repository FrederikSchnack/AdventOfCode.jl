module Day02
    using ..AdventOfCode24

    """
        day02()

    Solves the two puzzles of day 02. 
    """

    function day02(input::String = readInput(02))
        r = r"(\d+)"

        s0 = 0
        s1 = 0

        for l in split(input, "\n")
           
            n = [parse(Int, m.match) for m in eachmatch(r, l)]

            if is_safe(n)
                s0 += 1 
                s1 += 1
            else

                for k in eachindex(n)
                    # n0 = deleteat!(copy(n), k)
                    if is_safe(n[begin:end .!= k])
                        s1 += 1
                        break
                    end
                end

            end

        end

        return [s0, s1]
    end


    function is_safe(n::Vector{Int})
        diffs = diff(n)

        if all(@. 0 < diffs <= 3 ) || all(@. 0 > diffs >= -3) 
            return true
        else
            return false
        end
    end

end