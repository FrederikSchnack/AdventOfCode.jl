module Day15

    using ..AdventOfCode22

    """
        day15()

    Solves the two puzzles of day 15. 
    """
    function day15(input::String = readInput(15))
        reg = r"Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)"

        beacons = Set{Tuple{Int, Int}}()
        scanners = Set{Tuple{Int, Int}}()
        balls = Ball[]

        beacon_in_y = Set{Int}()
        y= 2000000
        yys = Set{UnitRange{Int}}()
        for line in split(input, "\n")
            xs, ys, xb, yb = parse.(Int, match(reg, line).captures)
            scanner = (xs, ys)
            beacon = (xb, yb)
            yb == y && push!(beacon_in_y, xb)
            push!(scanners, scanner)
            push!(beacons, beacon)
            radius = sum(abs.(scanner .- beacon))
            push!(balls, Ball(scanner, radius))

            dist_y = abs(ys - y)
            dist_x = radius - dist_y
            dist_x > 0 && push!(yys, xs-dist_x :xs+dist_x)
        end

        s0 = length(union(collect.(yys)...)) - length(beacon_in_y )

        llim = 0
        rlim = 4000000
        s1  = (0,0)

        a_coeff = Int[]
        b_coeff = Int[]

        for b in balls
            border_coeff!(a_coeff, b_coeff, b)
        end

        s1 = 0
        for (a,b) in Iterators.product(a_coeff, b_coeff)
            x,y = intersect_borders(a, b)
            
            if x ≥ llim && x ≤ rlim && y ≥ llim && y ≤ rlim && !any(isin.(Ref((x,y)), balls))
                s1 = x*rlim + y
                break
            end
        end
        
        return [s0, s1]
    end

    struct Ball
        middle::Tuple{Int, Int}
        radius::Int
    end

    function border_coeff!(a::Vector{Int},b::Vector{Int}, ball1::Ball)
        x,y = ball1.middle
        r = ball1.radius

        push!(a, y-x+r+1, y-x-r-1)
        push!(b, y+x+r+1, y+x-r-1)
    end

    function intersect_borders(a, b)
        return ((b-a)÷2, (a+b)÷ 2)
    end

    function isin(pt::Tuple{Int, Int}, b::Ball)
        r = sum(abs.(pt .- b.middle))
        return r ≤ b.radius
    end
end # module