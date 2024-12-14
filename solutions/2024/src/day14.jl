module Day14
    using ..AdventOfCode24

    """
        day14()

    Solves the two puzzles of day 14. 
    """

    function day14(input::String = readInput(14))
        r = r"p=(\d+),(\d+) v=(\-?\d+),(\-?\d+)"

        p = Vector{Tuple{Int, Int}}()
        v = Vector{Tuple{Int, Int}}()

        for k in eachmatch(r, input)
            x,y, vx, vy = parse.(Int, k.captures)
            push!(p, (x, y))
            push!(v, (vx, vy))
        end

        q = [0,0,0,0]

        for (pp,vv) in zip(p, v)
            x,y = pp
            vx, vy = vv

            step!(x, y, vx, vy, 100, q)
        end

        s0 = prod(q)

        s1 = 0

        while true
            for (i,(pp,vv)) in enumerate(zip(p, v))

                x,y = pp
                vx, vy = vv

                x_ = mod(x + vx, m) 
                y_ = mod(y + vy, n)

                p[i] = (x_, y_)
            end

            s1 += 1

            if allunique(p)
                break
            end
            
        end

  
        return [s0, s1]
    end

    const m = 101
    const n = 103

    function step!(x::Int, y::Int, vx::Int, vy::Int, steps::Int, q::Vector{Int})
        mh = Int((m-1)/2)
        nh = Int((n-1)/2)

        x = mod(x + steps * vx, m) 
        y = mod(y + steps * vy, n)

        if x > mh 
            if y > nh
                q[1] += 1
            elseif y < nh
                q[2] += 1
            end
        elseif x < mh
            if y > nh
                q[3] += 1
            elseif y < nh
                q[4] += 1
            end
        end

    end
end 

