module AdventOfCode23

    using AdventOfCode
    using Printf
    
    readInput(day::Int) = AdventOfCode.readInput(day, @__DIR__)
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
            function $dsSymbol(input::String = AdventOfCode22.readInput($d))
                return AdventOfCode22.$modSymbol.$dsSymbol(input)
            end
            export $dsSymbol
        end
    end
end # module AdventOfCode22
