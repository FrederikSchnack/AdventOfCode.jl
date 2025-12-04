module Day04
    using ..AdventOfCode25

    """
        day04()

    Solves the two puzzles of day 04. 
    """

    function day04(input::String = readInput(04))
        s0 = 0
        s1 = 0

        lines = split(input)
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]

        rem = CartesianIndex{2}[CartesianIndex(0,0)]

        while !isempty(rem)

            rolls = findall(==('@'), grid)
            empty!(rem)

            for paper in rolls
                check_around(paper, grid) && push!(rem, paper)
            end

            iszero(s0) && (s0 = length(rem))
            s1 += length(rem)

            grid[rem] .= '.'
        end

        return [s0, s1]
    end

    function check_around(pos::CartesianIndex{2}, grid::Matrix{Char})

        n = 0

        for d in directions
            get(grid, pos + d, '.') == '@' && (n += 1)
            n > 3 && return false
        end

        return true

    end

    const   directions = (CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1), 
                    CartesianIndex(1, 1), CartesianIndex(1, -1), CartesianIndex(-1, 1), CartesianIndex(-1, -1))
end 


