module AdventOfCode24

    using AdventOfCode
    using Printf
    
    const year = 24

    readInput(day::Int) = AdventOfCode.readInput(day, year)
    export readInput

    solvedDays = []

    # Include the source files:
    for day in solvedDays
        ds = @sprintf("%02d", day)
        include(joinpath(@__DIR__, "day$ds.jl"))
    end

    # Export a function `dayXY` for each day:
    for d in solvedDays
        modSymbol = Symbol(@sprintf("Day%02d", d))
        dsSymbol = Symbol(@sprintf("day%02d", d))

        @eval begin
            function $dsSymbol(input::String = AdventOfCode24.readInput($d))
                return AdventOfCode24.$modSymbol.$dsSymbol(input)
            end
            export $dsSymbol
        end
    end
end # module AdventOfCode24
