module Day08
    using ..AdventOfCode21

    """
        day08()

    Solves the two puzzles of day 8. 
    """
    function day08(input::String = readInput(8))

        s0 = 0
        s1 = 0
        
        for line in split(input, "\n")

            line = split(line, " ")
            first = line[1:end-5]
            second = line[end-3:end]

            one = ""
            four = ""
            for seg in first
                n = length(seg)
                
                if n == 2
                    one = seg
                elseif n == 4
                    four = seg
                end
            end

            bd = setdiff(four, one)

            num = ""
            for seg in second
                n = length(seg)

                if n == 2 
                    num *= "1"
                    s0 += 1
                elseif n == 3
                    num *= "7"
                    s0 += 1
                elseif n == 4
                    num *= "4"
                    s0 += 1
                elseif n == 7
                    num *= "8"
                    s0 += 1
                elseif n == 6
                    if issubset(one, seg)
                        if issubset(bd, seg)
                            num *= "9"
                        else 
                            num *= "0"
                        end
                    else
                        num *= "6"
                    end
                else
                    if issubset(one, seg)
                        num *= "3"
                    elseif issubset(bd, seg)
                        num *= "5"
                    else
                        num *= "2"
                    end
                end
                
            end

            s1 += parse(Int, num)
        end

        return [s0, s1]
    end

end 
