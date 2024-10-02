module Day14
    using ..AdventOfCode21

    """
        day14()

    Solves the two puzzles of day 14. 
    """
    function day14(input::String = readInput(14))
        lines = split(input, '\n')

        poly = [lines[1]...] 
        poly_pairs = Dict{Tuple{Char, Char}, Int}()
        counter = Dict{Char, Int}()

        rules = Dict{Tuple{Char, Char}, Char}()
        regex = r"(\w)(\w) -> (\w)"

        for l in lines[3:end]
            l1, l2, r = only.(match(regex, l).captures)
            rules[(l1, l2)] = r
            poly_pairs[(l1, l2)] = 0
            counter[l1] = 0
            counter[l2] = 0
            counter[r] = 0
        end

        for i in 1:length(poly)-1
            c1 = poly[i]
            c2 = poly[i+1]
            poly_pairs[(c1, c2)] += 1
            counter[c1] += 1
        end
        counter[poly[end]]+=1
        

        for _ in 1:10
            ppoly_pairs = deepcopy(poly_pairs)
            for (k,v) in ppoly_pairs
                if v > 0
                    poly_pairs[k] -= v

                    a = rules[k]
                    counter[a] += v
                    poly_pairs[(k[1], a)] += v
                    poly_pairs[(a, k[2])] += v
                end
            end

        end

        s0 = maximum(values(counter))-minimum(values(counter))

        for _ in 11:40
            ppoly_pairs = deepcopy(poly_pairs)
            for (k,v) in ppoly_pairs
                if v > 0
                    poly_pairs[k] -= v

                    a = rules[k]
                    counter[a] += v
                    poly_pairs[(k[1], a)] += v
                    poly_pairs[(a, k[2])] += v
                end
            end

        end
        s1 = maximum(values(counter))-minimum(values(counter))
     

        return [s0, s1]
    end




end 
