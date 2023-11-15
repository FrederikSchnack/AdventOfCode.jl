module Day08

    using ..AdventOfCode22

    """
        day08()

    Solves the two puzzles of day 8. 
    """
    function day08(input::String = readInput(8))
        lines = split(input, "\n")
        visible = Set{Tuple{Int64, Int64}}()
        n = length(lines[1])

        # using a Matrix is faster than working on a Vector of Strings
        L = Matrix{Int}(undef, n, n)
        for i in 1:n
            for j in 1:n
                L[i,j] = parse(Int, lines[i][j])
            end
        end

        # left and right boundary
        for i in 1:n
            curr = L[i,1]
            push!(visible, (i, 1))
            for j in 2:n
                if L[i,j] > curr
                    curr = L[i,j]
                    push!(visible, (i, j))
                    if curr == 9
                        break
                    end
                end
            end

            curr = L[i,n]
            push!(visible, (i, n))
            for j in n-1:-1:1
                if L[i,j] > curr
                    curr = L[i,j]
                    push!(visible, (i, j))
                    if curr == 9
                        break
                    end
                end
            end
        end 

        # upper and lower boundary
        for j in 1:n
            curr = L[1,j]
            push!(visible, (1, j))
            for i in 2:n
                if L[i,j] > curr
                    curr = L[i,j]
                    push!(visible, (i, j))
                    if curr == 9
                        break
                    end
                end
            end

            curr = L[n,j]
            push!(visible, (n, j))
            for i in n-1:-1:1
                if L[i,j] > curr
                    curr = L[i,j]
                    push!(visible, (i, j))
                    if curr == 9
                        break
                    end
                end
            end
        end

        s0 = length(visible)

        s1 = 0
        # loop over all points in the interior
        for ii in 2:n-1
            for jj in 2:n-1
                s1_ = 1
                curr = L[ii,jj]

                # look in each direction and calculate scores
                r_score = 0
                for j in jj+1:n
                    if L[ii,j] ≥ curr
                        r_score += 1
                        break
                    elseif L[ii,j] < curr
                        r_score += 1
                    end
                end
                s1_ *= r_score
            
                l_score = 0
                for j in jj-1:-1:1
                    if L[ii,j] ≥ curr
                        l_score += 1
                        break
                    elseif L[ii,j] < curr
                        l_score += 1
                    end
                end
                s1_ *= l_score
                
                u_score = 0
                for j in ii-1:-1:1
                    if L[j,jj] ≥ curr
                        u_score += 1
                        break
                    elseif L[j,jj] < curr
                        u_score += 1
                    end
                end
                s1_ *= u_score
                
                d_score = 0
                for j in ii+1:n
                    if L[j,jj] ≥ curr
                        d_score += 1
                        break
                    elseif L[j,jj] < curr
                        d_score += 1
                    end
                end
                s1_ *= d_score

                s1 = s1_ > s1 ? s1_ : s1
            end
        end

        return [s0, s1]
    end

end # module