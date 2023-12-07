module Day07
    using ..AdventOfCode23
    using DataStructures

    """
        day07()

    Solves the two puzzles of day 07. 
    """


    struct Hand
        cards::AbstractString
        bid::Int
        value_0::Int
        value_1::Int
    end
    
    const ctv_0 = Dict{Char, Int}('A'=>14, 'K'=>13, 'Q'=>12, 'J'=>11, 'T'=> 10, '9'=> 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2)
    const ctv_1 = Dict{Char, Int}('A'=>14, 'K'=>13, 'Q'=>12, 'J'=>1, 'T'=> 10, '9'=> 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2)

    function Hand(cards::AbstractString, bid::Int)

        value_0 = sum(10^(10-2i) * ctv_0[cards[i]] for i in eachindex(cards))::Int
        value_0 += 10^10 * card_type_0(cards)::Int
        
        if 'J' in cards
            value_1 = sum(10^(10-2i) * ctv_1[cards[i]] for i in eachindex(cards))::Int
            value_1 += 10^10 * card_type_1(cards)::Int
        else 
            value_1 = value_0
        end

        return Hand(cards, bid, value_0, value_1)
    end

    function type_from_counter(v::Int, n::Int)::Int
        if v == 5 
            return 7 
        elseif v == 4 
            if n == 2
                return 6
            else 
                return 3 
            end
        elseif v == 6 
            return 5 
        elseif v == 3 
            return 4 
        elseif v == 2 
            return 2 
        elseif v == 1 
            return 1 
        end
    end

    function card_type_0(cards::AbstractString)
        cc = counter(cards)
        n = length(cc)
        v = prod(values(cc))
        
        return type_from_counter(v, n)
    end

    function isless_0(a::Hand, b::Hand)
        return a.value_0 < b.value_0
    end

    function card_type_1(cards::AbstractString)
        cc = counter(cards)
        nj = cc['J']
        (nj == 5) && (return 7) 
        delete!(cc.map, 'J')
        
        val = sort(values(cc))
        val[end] += nj 
        v = prod(val)
        n = length(val)

        return type_from_counter(v, n)::Int
    end

    function isless_1(a::Hand, b::Hand)
        return a.value_1 < b.value_1
    end

    function day07(input::String = readInput(07))
        hands = Hand[]
        
        for h in findall(r"(.{5}) (\d+)", input)
            push!(hands, Hand(input[h[1:5]], parse(Int, input[h[7:end]])))
        end

        sort!(hands, lt = isless_0)
        s0 = sum(h.bid * i for (i, h) in enumerate(hands))

        sort!(hands, lt = isless_1)
        s1 = sum(h.bid * i for (i, h) in enumerate(hands))

        return [s0, s1]
    end
end 

