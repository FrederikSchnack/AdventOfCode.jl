module Day09
    using ..AdventOfCode21

    """
        day09()

    Solves the two puzzles of day 9. 
    """
    function day09(input::String = readInput(9))
        lines = split(input, "\n")
        sizes = Int[]

        basins = Set{Tuple{Int, Int}}()
        n = length(lines)
        m = length(lines[1])
        s0 = 0

        for i in 1:n
            for k in 1:m
                
                !check_lowpoint(lines, i, k) && continue

                val = lines[i][k]
                s0 += 1 + parse.(Int, val)
                size = check_basin_size(lines, i, k, 0, basins)
                push!(sizes, size)
            end
        end

        s1 = prod(sort(sizes)[end-2:end])

        return [s0, s1]

    end

    function check_lowpoint(lines::Vector, i::Int, k::Int)

        val = lines[i][k]
        val == '9' && return false

        n = length(lines)
        m = length(lines[1])        

        if k != m 
            val >= lines[i][k+1] && (return false)
        end
        if k != 1 
            val >= lines[i][k-1] && (return false)
        end

        if i != n 
            val >= lines[i+1][k] && (return false)
        end
        if i != 1 
            val >= lines[i-1][k] && (return false)
        end

        return true
    end
    
    function check_basin_size(lines::Vector, i::Int, k::Int, size::Int, visited::Set{Tuple{Int, Int}})

        val = lines[i][k]
        val == '9' && return size

        n = length(lines)
        m = length(lines[1])
        val = lines[i][k]

        push!(visited, (i,k))

        if k != m
            ((val < lines[i][k+1] ) && !((i, k+1) in visited)) && (size = check_basin_size(lines, i, k+1, size, visited))
        end
        if k != 1
            ((val < lines[i][k-1]) && !((i, k-1)  in visited)) && (size = check_basin_size(lines, i, k-1, size, visited))
        end

        if i != n
            ((val < lines[i+1][k] )& !((i+1, k)  in visited)) && (size = check_basin_size(lines, i+1, k, size, visited))
        end
        if i != 1
            ((val < lines[i-1][k] )& !((i-1, k)  in visited)) && (size = check_basin_size(lines, i-1, k, size, visited))
        end
        
        return size + 1
    end

end 
