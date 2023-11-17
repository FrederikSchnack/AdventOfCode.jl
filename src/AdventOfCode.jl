module AdventOfCode

    using BenchmarkTools
    using Printf    
   
    include("utilities.jl")

    include(joinpath(@__DIR__, "../2021/src/AdventOfCode21.jl"))
    include(joinpath(@__DIR__, "../2022/src/AdventOfCode22.jl"))
    include(joinpath(@__DIR__, "../2023/src/AdventOfCode23.jl"))
end
