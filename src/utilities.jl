# Read the input from a file:
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

function readInput(day::Int, directory::String)
    path = joinpath(directory, "../inputs", @sprintf("day%02d.txt", day))
    return readInput(path)
end

# Benchmark a list of different problems:
function benchmark(year::Int, days::Vector{Int}=Int[])
    results = []

    ySymbol = Symbol("AdventOfCode"*@sprintf("%02d", year))
    if isempty(days)
        days = @eval AdventOfCode.$ySymbol.solvedDays
    end

    for day in days
        modSymbol = Symbol(@sprintf("Day%02d", day))
        fSymbol = Symbol(@sprintf("day%02d", day))
        input = readInput(joinpath(@__DIR__,"..", "20"*@sprintf("%02d", year), "inputs", @sprintf("day%02d.txt", day)))
        @eval begin
            bresult = @benchmark(AdventOfCode.$ySymbol.$modSymbol.$fSymbol($input))
        end
        push!(results, (day, time(bresult), allocs(bresult), memory(bresult)))
    end
    return results
end

# Write the benchmark results into a markdown string:
function _to_markdown_table(bresults::Vector)
    header = "| Day | Time | Number of allocations | Allocated memory |\n" *
             "|----:|-----:|----------------------:|-----------------:|"

    lines = [header]
    for (d, t, a, m) in bresults
        ds = string(d)
        ts = BenchmarkTools.prettytime(t)
        ms = BenchmarkTools.prettymemory(m)
        push!(lines, "| $ds | $ts | $a| $ms |")
    end
    return join(lines, "\n")
end

function benchmark_for_readme(years::Vector{Int}=[21, 22])
    readme = "# AdventOfCode.jl \n 
    [![Build Status](https://github.com/FrederikSchnack/AdventOfCode.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/FrederikSchnack/AdventOfCode.jl/actions/workflows/CI.yml?query=branch%3Amain) \n"
    
    for year in years
        str = _to_markdown_table(benchmark(year))

        readme = join([readme,"\n ## 20"*@sprintf("%02d", year)*"\n", str])

    end

    open("README.md", "w") do io
        write(io, readme)
    end


end