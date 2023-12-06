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
        rd = r"(\d)"
        r = r"(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine)|(\d)"
        r_r = r"(eno)|(owt)|(eerht)|(ruof)|(evif)|(xis)|(neves)|(thgie)|(enin)|(\d)"

        for line in split(input, "\n")

            enil = reverse(line)

            s0 += 10 * parser[line[findfirst(rd, line)]] + parser[enil[findfirst(rd, enil)]]
            s1 += 10 * parser[line[findfirst(r, line)]] + parser[enil[findfirst(r_r, enil)]]
        end

        return [s0, s1]
    end

end