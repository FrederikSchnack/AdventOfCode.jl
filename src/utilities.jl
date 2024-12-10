# Read the input from a file:
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

function get_input_path(day::Int, year::Int)
    return joinpath(@__DIR__, "../inputs",  "20"*@sprintf("%02d", year), @sprintf("day%02d.txt", day))
end

function get_solution_path(day::Int, year::Int)
    return joinpath(@__DIR__, "../solutions",  "20"*@sprintf("%02d", year), "src", @sprintf("day%02d.jl", day))
end

function get_test_path(year::Int)
    return joinpath(@__DIR__, "../solutions",  "20"*@sprintf("%02d", year), "test", "runtests.jl")
end

function readInput(day::Int, year::Int)
    path = get_input_path(day, year)
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
        input = readInput(get_input_path(day, year))
        @eval begin
            bresult = @benchmark(AdventOfCode.$ySymbol.$modSymbol.$fSymbol($input))
        end
        push!(results, (day, time(bresult), allocs(bresult), memory(bresult)))
    end
    return results
end

function append_benchmark(year::Int, day::Int)
    bresult = benchmark(year, [day])

    d, t, a, m =  bresult[1]
    ds = @sprintf("%02d", d)
    ts = BenchmarkTools.prettytime(t)
    ms = BenchmarkTools.prettymemory(m)
    line =  "\n| $ds | $ts | $a| $ms |"
    
    open("README.md", "a") do io
        write(io, line)
    end
end

# Write the benchmark results into a markdown string:
function _to_markdown_table(bresults::Vector)
    header = "| Day | Time | Number of allocations | Allocated memory |\n" *
             "|----:|-----:|----------------------:|-----------------:|"

    lines = [header]
    for (d, t, a, m) in bresults
        ds = @sprintf("%02d", d)
        ts = BenchmarkTools.prettytime(t)
        ms = BenchmarkTools.prettymemory(m)
        push!(lines, "| $ds | $ts | $a| $ms |")
    end
    return join(lines, "\n")
end

function benchmark_for_readme(years::Vector{Int}=[21, 22, 23])
    readme = "# AdventOfCode.jl \n![Build Status](https://github.com/FrederikSchnack/AdventOfCode.jl/actions/workflows/CI.yml/badge.svg?branch=main)    \n"
    
    for year in years
        str = _to_markdown_table(benchmark(year))

        readme = join([readme,"\n ## 20"*@sprintf("%02d", year)*"\n", str])

    end

    open("README.md", "w") do io
        write(io, readme)
    end

end

function create_files(day::Int, year::Int)
    d = @sprintf("%02d", day)
    y = @sprintf("%02d", year)

    path = get_input_path(day, year)
    touch(path)

    src = get_solution_path(day, year)
    touch(src)

    template = """module Day$d
        using ..AdventOfCode$y

        \"""
            day$d()

        Solves the two puzzles of day $d. 
        \"""

        function day$d(input::String = readInput($d))

        end
    end 

    """
    open(src, "a") do io
        write(io, template)
    end

    tst = get_test_path(year)

    test = """

    @testset "Day $d" begin
        @test AdventOfCode$y.Day$d.day$d() == [s0, s1]
    end
    """

    open(tst, "a") do io
        write(io, test)
    end
end