module Day01
    using ..AdventOfCode23

    """
        day01()

    Solves the two puzzles of day 1. 
    """

    function day01(input::String = readInput(01))

        s0 = 0
        s1 = 0

        parser = Dict{String, Int}("1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9,
                                "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9,
                                "eno" => 1, "owt" => 2, "eerht" => 3, "ruof" => 4, "evif" => 5, "xis" => 6, "neves" => 7, "thgie" => 8, "enin" => 9)
        re0 = r"(\d)"
        re1 = r"(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine)|(\d)"
        re1_r = r"(eno)|(owt)|(eerht)|(ruof)|(evif)|(xis)|(neves)|(thgie)|(enin)|(\d)"

        for line in split(input, "\n")

            enil = reverse(line[1:end])

            s0 += 10 * parser[line[findfirst(re0, line)]] + parser[enil[findfirst(re0, enil)]]
            s1 += 10 * parser[line[findfirst(re1, line)]] + parser[enil[findfirst(re1_r, enil)]]
        end

        return [s0, s1]
    end

end