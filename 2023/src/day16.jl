module Day16
    using ..AdventOfCode23

    """
        day16()

    Solves the two puzzles of day 16. 
    """

    function day16(input::String = readInput(16))
        lines = split(input, "\n")
        energized = Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}(CartesianIndex(1,1) => Set{CartesianIndex{2}}([CartesianIndex(1,0)]))

        send_beam(CartesianIndex(1,1), CartesianIndex(1,0), energized, lines)
        s0 = length(collect(keys(energized)))
        s1 = 0
        n = length(lines)
        m = length(lines[1])
        for i in 1:n
            energized = Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}(CartesianIndex(i,1) => Set{CartesianIndex{2}}([CartesianIndex(0,1)]))
            send_beam(CartesianIndex(i,1), CartesianIndex(0,1), energized, lines)
            s = length(collect(keys(energized)))
            s1 = max(s, s1)

            energized = Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}(CartesianIndex(i,n) => Set{CartesianIndex{2}}([CartesianIndex(0,-1)]))
            send_beam(CartesianIndex(i,n), CartesianIndex(0,-1), energized, lines)
            s = length(collect(keys(energized)))
            s1 = max(s, s1)

            energized = Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}(CartesianIndex(1,i) => Set{CartesianIndex{2}}([CartesianIndex(1,0)]))
            send_beam(CartesianIndex(1,i), CartesianIndex(1,0), energized, lines)
            s = length(collect(keys(energized)))
            s1 = max(s, s1)

            energized = Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}(CartesianIndex(n,i) => Set{CartesianIndex{2}}([CartesianIndex(-1,0)]))
            send_beam(CartesianIndex(n,i), CartesianIndex(-1,0), energized, lines)
            s = length(collect(keys(energized)))
            s1 = max(s, s1)
        end

        return [s0,s1]
    end

    const mirrors = Dict{Tuple{Char, CartesianIndex{2}}, Vector{CartesianIndex{2}}}( 
    ('\\', CartesianIndex(1,0)) => [CartesianIndex(0, 1)], 
    ('\\', CartesianIndex(-1,0)) => [CartesianIndex(0, -1)], 
    ('\\', CartesianIndex(0,1)) => [CartesianIndex(1, 0)], 
    ('\\', CartesianIndex(0,-1)) => [CartesianIndex(-1, 0)],
    ('/', CartesianIndex(1,0)) => [CartesianIndex(0, -1)],
    ('/', CartesianIndex(-1,0)) => [CartesianIndex(0, 1)],
    ('/', CartesianIndex(0,1)) => [CartesianIndex(-1, 0)],
    ('/', CartesianIndex(0,-1)) => [CartesianIndex(1, 0)],
    ('.', CartesianIndex(1,0)) => [CartesianIndex(1, 0)],
    ('.', CartesianIndex(-1,0)) => [CartesianIndex(-1, 0)],
    ('.', CartesianIndex(0,1)) => [CartesianIndex(0, 1)],
    ('.', CartesianIndex(0,-1)) => [CartesianIndex(0, -1)],
    ('-', CartesianIndex(1,0)) => [CartesianIndex(1, 0)],
    ('-', CartesianIndex(-1,0)) => [CartesianIndex(-1, 0)],
    ('-', CartesianIndex(0,1)) => [CartesianIndex(1, 0), CartesianIndex(-1,0)],
    ('-', CartesianIndex(0,-1)) => [CartesianIndex(1,0), CartesianIndex(-1,0)], 
    ('|', CartesianIndex(1,0)) => [CartesianIndex(0,-1), CartesianIndex(0, 1)],
    ('|', CartesianIndex(-1,0)) => [CartesianIndex(0, -1), CartesianIndex(0, 1)],
    ('|', CartesianIndex(0,1)) => [CartesianIndex(0, 1)],
    ('|', CartesianIndex(0,-1)) => [CartesianIndex(0,-1)], 
    )

    function send_beam(position::CartesianIndex{2}, direction::CartesianIndex{2}, energized::Dict{CartesianIndex{2}, Set{CartesianIndex{2}}}, lines::Vector{SubString{String}})
        next_position = position + direction
        if !(0 < next_position[2] <= length(lines)) || !(0 < next_position[1] <= length(lines[1]))
            return nothing  
        end

        if next_position in keys(energized)
            if direction in energized[next_position]
                return nothing 
            else
                push!(energized[next_position], direction)
            end
        else
            energized[next_position] = Set([direction])
        end

        tile = lines[next_position[2]][next_position[1]]

        for d in mirrors[(tile, direction)]
            send_beam(next_position, d, energized, lines)
        end

        return nothing 
    end
end 

