module Day03
    using ..AdventOfCode21

    """
        day03()

    Solves the two puzzles of day 3. 
    """
    function day03(input::String = readInput(3))
        
        lines = split(input, "\n")
        m = length(lines[1])
        n = length(lines)
        L = BitMatrix(undef, n, m)
        for l in 1:n
            L[l, :] = parse.(Int, [lines[l]...])
        end

        bits = sum(L, dims=1) ./ n
        gamma = bits[1, :] .> 0.5
        epsilon = .!gamma
        s0 = to_int(gamma) * to_int(epsilon)

        ind_oxy = BitVector(1 for _ in 1:n)
        ind_co2 = deepcopy(ind_oxy)

        for j in 1:m
            a = sum(ind_oxy)  
            a > 1 &&  (sum(L[ind_oxy, j]) ≥ a/2 ? ind_oxy .*= (L[:, j] .== 1)   : ind_oxy .*= (L[:, j] .== 0)) 
            
            b = sum(ind_co2)
            b > 1 && (sum(L[ind_co2, j]) < b/2 ? ind_co2 .*= (L[:, j] .== 1)   : ind_co2 .*= (L[:, j] .== 0) )
        end

        oxy = to_int(L[ind_oxy, :][1, :])
        co2 = to_int(L[ind_co2, :][1, :])
        s1 = oxy * co2

        return [s0, s1]

    end

    function to_int(s::BitVector)
        return sum([s[1+end-i]*2^(i-1) for i in eachindex(s)])
    end

end
