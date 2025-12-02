module Day02
    using ..AdventOfCode25

    """
        day02()

    Solves the two puzzles of day 02. 
    """

    function day02(input::String = readInput(02))
        s0 = 0
        s1 = 0

        for l in split(input, ",")
            a, b = parse.(Int, split(l, "-"))

            s0 += extend(a, b, true)
            s1 += extend(a, b)

        end

        return [s0, s1]
    end


    function extend(a::Int, b::Int, part1::Bool)

        s = Set{Int}()

        bn = length(string(b))
        
        ds = string(a)
        dn = length(ds)

        while dn <= bn

            if part1 
                vs = ds[1:cld(dn, 2)]^2
                v = parse(Int, vs)
                (a <= v <= b) && push!(s, v)
                      
            else 

                for l in 1:dn
                    for i in dn÷l:bn÷l

                        i == 1 && continue
                        vs = ds[1:l]^i
                        v = parse(Int, vs)
                        (a <= v <= b) && push!(s, v)
                    end
                    
                end

            end

            d = parse(Int, ds[1:cld(dn,2)])+1
            d = d * 10^(dn÷2)
            (d > b) && break
            
            ds = string(d)
            dn = length(ds)

        end

        return sum(s)
    end

end 

