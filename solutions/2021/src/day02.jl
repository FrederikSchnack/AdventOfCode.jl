module Day02
    using ..AdventOfCode21
    
    """
        day02()

    Solves the two puzzles of day 2. 
    """
    function day02(input::String = readInput(2))
        p0 = Position(0,0,0)
        p1 = Position(0,0,0)

        for l in split(input, "\n")
            com, val = split(l, " ")
            move0!(p0, com, parse(Int, val))
            move1!(p1, com, parse(Int, val))

        end

        s0 = p0.horizontal * p0.depth
        s1 = p1.horizontal * p1.depth

        return [s0, s1]
    end

    mutable struct Position
        horizontal::Int
        depth::Int
        aim::Int
    end

    function move0!(p::Position, com::AbstractString, val::Int)
        if com == "up"
            p.depth -= val
        elseif com == "down"
            p.depth += val
        elseif com == "forward"
            p.horizontal += val
        end
    end

    function move1!(p::Position, com::AbstractString, val::Int)
        if com == "up"
            p.aim -= val
        elseif com == "down"
            p.aim += val
        elseif com == "forward"
            p.horizontal += val
            p.depth += p.aim * val 
        end
    end

end
