module Day04
    using ..AdventOfCode24

    """
        day04()

    Solves the two puzzles of day 04. 
    """

    function day04(input::String = readInput(04))
        lines = split(input, "\n")
        n = length(lines)
        m = length(lines[1])

        s0 = 0

        for i in 1:n
            for j in findall(r"X", lines[i])
                j = j.start
                
                i+3 <= n && (s0 += check_next(i, j, 'X', lines, 0))
                j+3 <= m && (s0 += check_next(i, j, 'X', lines, 1))
                i-3 > 0 && (s0 += check_next(i, j, 'X', lines, 2))
                j-3 > 0 && (s0 += check_next(i, j, 'X', lines, 3))
                (i+3 <= n && j+3 <= m) && (s0 += check_next(i, j, 'X', lines, 4))
                (i-3 > 0 && j-3 > 0) && (s0 += check_next(i, j, 'X', lines, 5))
                (i-3 > 0 && j+3 <= m) && (s0 += check_next(i, j, 'X', lines, 6))
                (i+3 <= n && j-3 > 0) && (s0 += check_next(i, j, 'X', lines, 7))
            end
        end 

        s1 = 0
        for i in 1:n
           !((0 < i-1) && (i+1 <= n) ) && continue
            for j in findall(r"A", lines[i])
                j = j.start
                !( (0 < j-1) && (j+1 <= m) ) && continue

                if ((lines[i+1][j+1] == 'S' && lines[i-1][j-1] =='M') || (lines[i+1][j+1] == 'M' && lines[i-1][j-1] =='S')) && ( (lines[i+1][j-1] == 'S' && lines[i-1][j+1] =='M') || (lines[i+1][j-1] == 'M' && lines[i-1][j+1] =='S'))                        
                    s1 += 1
                end

            end
        end

        return [s0, s1]
    end

    function check_next(i::Int, j::Int, curr::Char, lines::Vector{SubString{String}}, type::Int)
        !(lines[i][j] == curr) && return 0
        curr == 'S' && return 1
        
        i_, j_ = next_ind(i, j, type)
        return check_next(i_,  j_, next[curr], lines, type)
    end
    
    const next = Dict('X' => 'M', 'M' => 'A', 'A' => 'S')

    function next_ind(i::Int, j::Int, type::Int)
        if type == 0
            return i+1, j
        elseif type == 1
            return i, j+1
        elseif type == 2
            return i-1, j
        elseif type == 3
            return i, j-1
        elseif type == 4
            return i+1, j+1
        elseif type == 5
            return i-1, j-1
        elseif type == 6
            return i-1, j+1
        elseif type == 7
            return i+1, j-1
        end
    end

end 
