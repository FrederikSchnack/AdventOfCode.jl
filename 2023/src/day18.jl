module Day18
    using ..AdventOfCode23

    """
        day18()

    Solves the two puzzles of day 18. 
    """

    function day18(input::String = readInput(18))

        ar_0 = 0
        bd_0 = 0
        prev_0 = CartesianIndex(1,1)

        ar_1 = 0
        bd_1 = 0
        prev_1 = CartesianIndex(1,1)

        for l in split(input, "\n")
            d = l[1]
            len = parse(Int, l[findfirst(r"(\d+)", l)])
            next = get_corner(prev_0, d, len) 
            bd_0 += abs(next[1] - prev_0[1]) + abs(next[2] - prev_0[2])
            ar_0 += 1/2 * (prev_0[1]*next[2] - prev_0[2]*next[1])
            prev_0 = next

            d, len = extract_hex(l[end-6:end-1])
            next = get_corner(prev_1, d, len) 
            bd_1 += abs(next[1] - prev_1[1]) + abs(next[2] - prev_1[2])
            ar_1 += 1/2 * (prev_1[1]*next[2] - prev_1[2]*next[1])
            prev_1 = next
        end
        s0 = Int(ar_0 + bd_0/2 + 1)
        s1 = Int(ar_1 + bd_1/2 + 1)

        return [s0, s1]
    end

    function get_corner(curr::CartesianIndex{2}, d::Char, len::Int)
        if d == 'U'
            return curr + CartesianIndex(0, -len)
        elseif d=='D'
            return curr + CartesianIndex(0, len)
        elseif d == 'L'
            return curr + CartesianIndex(-len, 0)
        elseif d=='R'
            return curr + CartesianIndex(len, 0)
        end
    end

    const to_dir = Dict{Char, Char}('0' => 'R', '1' => 'D', '2' => 'L', '3' => 'U')

    function extract_hex(s::AbstractString)
        return to_dir[s[end]], parse(Int, s[1:end-1], base=16)
    end
end 

