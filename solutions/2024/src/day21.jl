module Day21
    using ..AdventOfCode24
    using Memoize

    """
        day21()

    Solves the two puzzles of day 21. 
    """

    struct keypad
        grid::Matrix{Char}
        coords::Dict{Char, CartesianIndex{2}}
        
        keypad(grid::Matrix{Char}) = 
        new(grid, Dict(grid[x] => x for x in eachindex(IndexCartesian(), grid)))        
    end

    
    const numpad = keypad(['7' '8' '9'; '4' '5' '6'; '1' '2' '3'; ' ' '0' 'A'])
    const dirpad = keypad([' ' '^' 'A'; '<' 'v' '>'])

    function day21(input::String = readInput(21))
        s0 = 0
        s1 = 0

        for l in split(input)
            v = parse(Int, l[1:end-1])

            code = decode(numpad, l)

            cl0 = minimum( count_level(2, c) for c in code)
            cl1 = minimum( count_level(25, c) for c in code)

            s0 += v * cl0
            s1 += v * cl1
        end

        return [s0, s1]
        
    end


    function paths(a::CartesianIndex{2}, b::CartesianIndex{2}, grid::Matrix{Char})::Vector{String}
        a == b && return ["A"]

        a1, a2 = a.I
        b1, b2 = b.I
        
        d1 = b1-a1
        d2 = b2-a2

        d2 > 0 ? (cx = '>') : (cx = '<')
        d1 > 0 ? (cy = 'v') : (cy = '^')
        
        nx = abs(d2)
        ny = abs(d1)

        if size(grid) == (4,3) 
            if b2 == 1 && a1 == 4 
                return [cy^ny * cx^nx * 'A']
            elseif a2 == 1 && b1 == 4 
                return [cx^ny * cy^nx * 'A']
            end
        elseif size(grid) == (2,3)
            if b2 == 1 && a1 == 1 
                return [cy^ny * cx^nx * 'A']
            elseif a2 == 1 && b1 == 1 
                return [cx^nx * cy^ny * 'A']
            end
        end

        nx == 0 && return [cy^ny * 'A']
        ny == 0 && return [cx^nx * 'A']

        return [cy^ny * cx^nx * 'A', cx^nx * cy^ny * 'A']
    end


    function decode(pad::keypad, code::AbstractString, pos::CartesianIndex{2}=CartesianIndex{2}(0,0), path::String = "")::Vector{String}
        iszero(pos) && (pos = pad.coords['A'])
        isempty(code) && return [path]

        target = pad.coords[code[1]]

        res = String[]
        for p in paths(pos, target, pad.grid)
            append!(res, decode(pad, code[2:end], target, path*p))
        end

        return res

    end

    @memoize function count_level(level, code)::Int
        level == 0 && (return length(code))

        minlength = 0
        start = 'A'

        for key in code
            len = Inf

            for path in paths(dirpad.coords[start], dirpad.coords[key], dirpad.grid)
            
                l = count_level(level-1, path)
                l < len && (len = l)

            end

            start = key
            minlength += len
        end

        return minlength
    end

end
