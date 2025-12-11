module Day11
    using ..AdventOfCode25
    using Memoize

    """
        day11()

    Solves the two puzzles of day 11. 
    """

    function day11(input::String = readInput(11))
        devices = Dict{String, Vector{String}}()

        for l in split(input, "\n")
            devices[l[1:3]] = split(l[5:end])
        end

        s0 = data_step_you(devices)
        s1 = data_step_svr(devices)

        return [s0, s1]
    end
    
    @memoize function data_step_you(devices::Dict{String, Vector{String}}, s::String="you")
        (s == "out") && (return 1)

        total = 0
        for next in devices[s]
            total += data_step_you(devices, next)
        end

        return total
    end

    @memoize function data_step_svr(devices::Dict{String, Vector{String}}, s::String="svr", dac::Bool=false, fft::Bool= false)
        if s == "out" 
            (dac && fft) ? (return 1) : (return 0)
        end

        s == "dac" && (dac = true)
        s == "fft" && (fft = true)
        
        total = 0
        for next in devices[s]
            total += data_step_svr(devices, next, dac, fft)
        end

        return total
    end

end 

