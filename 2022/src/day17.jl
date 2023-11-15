module Day17

    using ..AdventOfCode22

    """
        day17()

    Solves the two puzzles of day 17. 
    """
    function day17(input::String = readInput(17))
        n = length(input) 
        jet = Vector{Int}(undef, n)
        for k in 1:n
            if input[k] == '>'
                jet[k] = 1
            else
                jet[k] = -1
            end
        end
        s = 0

        g = Set{Tuple{Int, Int}}((j, 0) for j = 1:7)
        v = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()

        big_it = 1000000000000

        cn = big_it+1
        ch = big_it+1
        p = ( ( ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ) ),
        ( ( 1, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 2 ) ),
        ( ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 2, 1 ), ( 2, 2 ) ),
        ( ( 0, 0 ), ( 0, 1 ), ( 0, 2 ), ( 0, 3 ) ),
        ( ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 1, 1 ) ) )

        s0 = 0
        s1 = 0

        for n in 0:big_it
            h = maximum([y for (x,y) in g])

            if n == 2022
                s0 = h
            end

            x, y, r = 2, h + 4, n % 5
            if (s, r) in keys(v)
                cn = n - v[ ( s, r ) ][ 1 ]
                ch = h - v[ ( s, r ) ][ 2 ]
            end
            v[ ( s, r ) ] = ( n, h )
            if ( big_it - n ) % cn == 0
                h += ( big_it - n ) ÷ cn * ch
                s1 = h
                break
            end

            while true
                dx = jet[ s+1 ] 
                s = ( s + 1 ) % length( jet )
                if all( [!(( x + i + dx, y + j ) in g ) && 0 <= x + i + dx < 7
                        for (i, j) in p[r+1] ])
                    x += dx
                end

                if any([ ( x + i, y + j - 1 ) in g for (i, j) in p[ r+1 ] ])
                    break
                end
                y -= 1
            end

            for (i, j) in p[ r+1 ]
                push!(g, ( x + i, y + j ))
            end
        end

        return [s0, s1]
    end
     
end # module