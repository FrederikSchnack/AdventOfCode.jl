module Day12

    using ..AdventOfCode22

    """
        day12()

    Solves the two puzzles of day 12. 
    """
    function day12(input::String = readInput(12))
        lines = split(input, "\n")
        m = length(lines)
        n = length(lines[1])
        H = Matrix{Int}(undef, m, n)
      
        final = CartesianIndex{2}
        start0 = CartesianIndex{2}
        start1 = CartesianIndex{2}[]

        for i in 1:m
            for j in 1:n

                l = lines[i][j]
                if l == 'S'
                    start0 = CartesianIndex(i,j)
                    H[i,j] = 0
                elseif l == 'E'
                    final = CartesianIndex(i, j)
                    H[i,j] = 25
                else
                    H[i,j] = Int(l) - 97 # =Int('a')
                end
                
                H[i,j] == 0 && push!(start1, CartesianIndex(i,j))
            end
        end

        dist = dijkstra(H, final)

        s0 = dist[start0]
        s1 = minimum(dist[start1])

        return [s0, s1]
    end


    # backwards dijkstra
    function dijkstra(H::Matrix{Int}, final::CartesianIndex{2})
        cost = one.(H) .* 99999
        cost[final] = 0
        
        visited = zeros(Bool, size(H))
        visited[final] = true
        Q = CartesianIndex[final]

        shift = CartesianIndex.([(1,0), (-1,0), (0,1), (0,-1)])

        while !isempty(Q)
            u = popfirst!(Q)

            for s in shift
                a = u + s

                if checkbounds(Bool, H, a) && !visited[a] && H[u] - H[a] ≤ 1
                    push!(Q, a)
                    cost[a] = cost[u] + 1
                    visited[a] = true
                end
            end
        end
        
        return cost
    end

end # module