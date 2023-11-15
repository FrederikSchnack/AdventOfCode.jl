module Day02

    using ..AdventOfCode22

    
    """
        day02()

    Solves the two puzzles of day 2. 
    """
    function day02(input::String = readInput(2))

        outcome = Dict("A X" => 4,
        "A Y" => 8,
        "A Z" => 3,
        "B X" => 1,
        "B Y" => 5,
        "B Z" => 9,
        "C X" => 7,
        "C Y" => 2,
        "C Z" => 6)

        decision = Dict("A X" => "A Z",
        "A Y" => "A X",
        "A Z" => "A Y",
        "B X" => "B X",
        "B Y" => "B Y",
        "B Z" => "B Z",
        "C X" => "C Y",
        "C Y" => "C Z",
        "C Z" => "C X")

        s01 = 0
        s02 = 0

        for line in split(input, "\n")
            s01 += outcome[line]
            s02 += outcome[decision[line]]
        end

        return [s01, s02]
    end


end # module