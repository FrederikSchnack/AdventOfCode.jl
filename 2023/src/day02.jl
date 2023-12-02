 
module Day02
    using ..AdventOfCode23

    """
        day02()

    Solves the two puzzles of day 02. 
    """

    function day02(input::String = readInput(02))
       
        s0 = 0
        s1 = 0

        r = r"(\d+ \w)"
        bag = Dict{Char, Int}('g' => 0, 'r' => 0, 'b' =>0)

        for (i, game) in enumerate(split(input, "\n"))

            for round in split(game, ";")

                for k in findall(r, round)
                    val = parse(Int, round[k[1:end-2]])
                    (val > bag[round[k[end]]]) && (bag[round[k[end]]] = val)
                end

            end

            (bag['r'] <= 12 && bag['g'] <= 13 && bag['b'] <= 14) && (s0 += i)

            s1 += prod(values(bag))

            bag['g'] = 0; bag['r'] = 0; bag['b'] = 0
        end

        return [s0, s1]
    end
end 

