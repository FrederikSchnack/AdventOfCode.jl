module Day04
    using ..AdventOfCode21

    """
        day04()

    Solves the two puzzles of day 4. 
    """
    function day04(input::String = readInput(4))
        si = 5
        boards = Dict{Int , Matrix{Int}}()

        spl = split(input, "\n")
        com = parse.(Int, split(spl[1], ","))

        for (nu,k) in enumerate(3:6:length(spl))
            M = Matrix{Int}(undef, si, si)
            for j in 1:si
                M[:, j] = parse.(Int, split(spl[k+j-1], ' ', keepempty=false))
            end
            boards[nu] =  M
        end
        
        s0 = 0
        s1 = 0
        first = true 
        last = false
        for num in com

            for (ind, B) in boards

                B[findall(B .== num)] .= 10000000000

                if any(sum(B, dims = 1) .>= 50000000000) || any(sum(B, dims = 2) .>= 50000000000)
                    if first
                        s0 = sum(B[B .< 10000000000])*num
                        first=false
                    end

                    if last
                        s1 = sum(B[B .< 10000000000])*num
                        break
                    end

                    delete!(boards, ind)
                end
            end

            (s1 !== 0) && break
            (length(boards) == 1) && (last = true)
        end

        return [s0, s1]

    end



end 
