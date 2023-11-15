module Day03

    using ..AdventOfCode22


    """
        day03()

    Solves the two puzzles of day 3. 
    """
    function day03(input::String = readInput(3))
        s01 = 0
        s02 = 0

        lines = split(input, "\n")

        for k in eachindex(lines)
            line = lines[k]
            len = length(line)÷2
            left = line[1:len]
            right = line[1+len:end]
            
            for char in intersect(left, right)
                s01 += Int64(char) - (islowercase(char) ? 96 : 38)
            end

            if k%3 == 1
                val = intersect(lines[k:k+2]...)[1]
                s02 += Int64(val) - (islowercase(val) ? 96 : 38)
            end
        end

        return [s01, s02]
    end


end # module