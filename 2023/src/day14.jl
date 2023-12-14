module Day14
    using ..AdventOfCode23

    """
        day14()

    Solves the two puzzles of day 14. 
    """

    function day14(input::String = readInput(14))
        lines = split(input, "\n")
        n = length(lines)
        m = length(lines[1])

        rock = Set{CartesianIndex{2}}()
        rr = r"(\#)"
        block = Set{CartesianIndex{2}}()
        rb = r"(O)"

        for (y, l) in enumerate(lines)
            r_ind = findall(rr, l)
            b_ind = findall(rb, l)
            !isempty(r_ind) && push!(block, [CartesianIndex(x.start, y) for x in r_ind]...)
            !isempty(b_ind) && push!(rock,  [CartesianIndex(x.start, y) for x in b_ind]...)
        end
        

        history = Vector{UInt64}()
        scores = Int[]

        directions = (CartesianIndex(0,-1), CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(1,0))
        cycle = 0
        val = 4 * 1000000000
        while cycle < val
            tilt!(rock, block, directions[1 + cycle%4], (n,m))
            hrock = hash(rock)
            cycle += 1

            if cycle%4 == 0 && hrock in history 
                find = findfirst(x->x==hrock, history)
                cycle = find + (val - cycle)%(cycle-find)
                break
            end

            push!(history, hrock)
            push!(scores, get_score(rock, n))
        end
        
        s0 = scores[1]
        s1 = scores[cycle]

        return [s0, s1]
    end

    function tilt!(rock::Set{CartesianIndex{2}}, block::Set{CartesianIndex{2}}, dir::CartesianIndex{2}, lims::Tuple{Int, Int})

        moved = true
        while moved
            moved = false
            for r in rock
                
                new_r = r + dir
                if (lims[2] >= new_r[2] >= 1) && (lims[1]>=new_r[1]>=1) && !(new_r in rock) && !(new_r in block)
                    moved = true
                    delete!(rock, r)
                    push!(rock, new_r)
                end
            end
        end

    end

    function get_score(rock::Set{CartesianIndex{2}}, n::Int)
        return sum([n+1 - a[2] for a in rock])
    end
end 

