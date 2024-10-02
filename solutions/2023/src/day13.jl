module Day13
    using ..AdventOfCode23

    """
        day13()

    Solves the two puzzles of day 13. 
    """

    function day13(input::String = readInput(13))
        blocks = split(input, "\n\n")

        s0 = 0
        s1 = 0
        for block in blocks
            s0 += check_block(block)
            s1 += check_smudge(block)
        end

        return [s0, s1]
    end

    function check_block(block::SubString{String})
        lines = split(block, "\n")
        m = length(lines)
        n = length(lines[1])

        mp = 0
        done = false

        for i in 1:m-1

            mp = i

            if lines[i] == lines[i+1]
                done = true

                for k in 1:i
                    if (i+1+k) <= m && i-k > 0 
                        !(lines[i-k]==lines[i+1+k]) && (done = false)
                    end
                end

            end

            done && break 
        end

        done && return 100 * mp

        cols = [block[i:n+1:end] for i in 1:n]
        for i in 1:n-1

            mp = i

            if cols[i] == cols[i+1]
                done = true

                for k in 1:i
                    if (i+1+k) <= n && i-k > 0 
                        !(cols[i-k]==cols[i+1+k]) && (done = false)
                    end
                end

            end

            done && break 
        end

        done && return  mp

    end

   
    function check_smudge(block::SubString{String})
        lines = split(block, "\n")
        m = length(lines)
        n = length(lines[1])

        mp = 0
        done = false
        smudge = false 

        for i in 1:m-1

            mp = i

            if sum([lines[i][k] == lines[i+1][k] for k in 1:n]) == n-1
                done = true
                smudge = true

                for k in 1:i
                    if (i+1+k) <= m && i-k > 0 
                        !(lines[i-k]==lines[i+1+k]) && (done = false)
                    end
                end

            end
            (done && smudge) && break 

            done = false
            smudge = false
            if lines[i] == lines[i+1]
                done = true

                for k in 1:i
                    if (i+1+k) <= m && i-k > 0 
                        (!(lines[i-k]==lines[i+1+k]) && smudge == true) && (done = false)
                        (sum([lines[i-k][j] == lines[i+1+k][j] for j in 1:n]) == n-1) && (smudge = true)
                    end
                end

            end


            (done && smudge) && break 
        end

        (done && smudge) && return 100 * mp

        cols = [block[i:n+1:end] for i in 1:n]
        done = false
        smudge = false

        for i in 1:n-1

            mp = i

            if sum([cols[i][k] == cols[i+1][k] for k in 1:m]) == m-1
                done = true
                smudge = true
                
                for k in 1:i
                    if (i+1+k) <= n && i-k > 0 
                        !(cols[i-k]==cols[i+1+k]) && (done = false)
                    end
                end

            end

            (done && smudge) && break 

            done = false
            smudge = false

            if cols[i] == cols[i+1]
                done = true

                for k in 1:i
                    if (i+1+k) <= n && i-k > 0 
                        (!(cols[i-k]==cols[i+1+k]) && smudge == true) && (done = false)
                        (sum([cols[i-k][j] == cols[i+1+k][j] for j in 1:m]) == m-1) && (smudge = true)
                    end
                end
            end

            (done && smudge) && break 
        end

        (done && smudge) && return  mp
    end

end 

