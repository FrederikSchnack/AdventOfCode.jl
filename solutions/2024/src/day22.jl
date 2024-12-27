module Day22
    using ..AdventOfCode24

    """
        day22()

    Solves the two puzzles of day 22. 
    """

    function day22(input::String = readInput(22))
        s0 = 0
        n = 2000

        offer = Dict{Vector{Int}, Int}()
        seen = Set{Vector{Int}}()

        for l in split(input)
            secret = parse(Int, l)

            seq = zeros(Int, n+1)
            seq[1] = secret % 10

            d = zeros(Int, n)

            for i in 2:n+1
                secret = step(secret)
                seq[i] = secret % 10
                d[i-1] = seq[i-1] - seq[i]
            end
           
            s0 += secret

            empty!(seen)

            for i in 4:n
                dd = d[i-3:i]

                dd in seen && continue

                offer[dd] = get(offer, dd, 0) + seq[i+1]
                push!(seen, dd)

            end

        end

        s1 = maximum(values(offer))

        return [s0, s1]
    end

    mix(x::Int, y::Int) = xor(x, y)
    prune(x::Int) = mod(x, 16777216) 
    step1(x::Int) = prune(mix(64*x, x))
    step2(x::Int) = prune(mix(floor(Int, x/32),x))
    step3(x::Int) = prune(mix(x * 2048, x))
    step(x::Int) = step3(step2(step1(x)))

end 