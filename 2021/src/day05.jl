module Day05
    using ..AdventOfCode21

    """
        day05()

    Solves the two puzzles of day 5. 
    """
    function day05(input::String = readInput(5))
        lines = Dict{Tuple{Int, Int}, Int}()

        for s in split(input, "\n")
           read_line!(s, lines)
        end

        s0 = 0
        for v in values(lines)
            (v > 1) && (s0 += 1)
        end

        for s in split(input, "\n")
            read_line_diag!(s, lines)
        end

        s1 = 0
        for v in values(lines)
            (v > 1) && (s1 += 1)
        end

        return [s0, s1]
    end

    function read_line!(str::AbstractString, lines::Dict{Tuple{Int, Int}, Int})
        x1, y1, x2, y2 = parse.(Int, match(r"(\d*),(\d*) -> (\d*),(\d*)", str).captures)
        y1, y2 = min(y1, y2), max(y1, y2)
        x1, x2 = min(x1, x2), max(x1, x2)

        if x1 == x2
            for y in y1:y2
                pt = (x1, y)
                pt in keys(lines) ? lines[pt] += 1 : lines[pt] = 1
            end

        elseif y1 == y2
            for x in x1:x2
                pt = (x, y1)
                pt in keys(lines) ? lines[pt] += 1 : lines[pt] = 1
            end

        end

    end

    function read_line_diag!(str::AbstractString, lines::Dict{Tuple{Int, Int}, Int})
        x1, y1, x2, y2 = parse.(Int, match(r"(\d*),(\d*) -> (\d*),(\d*)", str).captures)

        if x1 != x2 &&  y1 != y2

            diff_1 = (x1 - x2)
            diff_2 = (y1 - y2)
            
            for k in 0:abs(diff_1)
                pt = (x2 + k*sign(diff_1), y2 + k*sign(diff_2))
                pt in keys(lines) ? lines[pt] += 1 : lines[pt] = 1
            end
        end

    end
end 
