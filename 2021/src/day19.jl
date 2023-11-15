module Day19
    using ..AdventOfCode21

    """
        day19()

    Solves the two puzzles of day 19. 
    """
    function day19(input::String = readInput(19))
       scanner = Dict{Int, Vector{Vector{Int}}}()

       for s in split(input, "--- scanner ", keepempty=false)
            nb = parse(Int, s[1:2])
            scanner[nb] = Tuple{Int, Int, Int}[]
            for j in split(s, "\n", keepempty=false)[2:end]
                push!(scanner[nb], parse.(Int, split(j, ',')))
            end
       end
    end

    const SIN = Dict{Int, Int}(0 => 0, 90 => 1, 180 => 0, 270 => -1)
    const COS = Dict{Int, Int}(0 => 1, 90 => 0, 180 => -1, 270 => 0)
    const ANGLES = Tuple{Int, Int, Int}[(0,0,90), (0,0,180), (0,0,270),
                                        #
                                        (0,90,90), (0,90,180), (0,90,270),
                                        (0,180,90), (0,180,180), (0,180,270),
                                        (0,270,90), (0,270,180), (0,270,270),
                                        #
                                        (0,0,90), (0,0,180), (0,0,270),
                                        (90,90,90), (90,90,180), (90,90,270),
                                        (90,180,90), (90,180,180), (90,180,270),
                                        (90,270,90), (90,270,180), (90,270,270),
                                        (180,0,90), (180,0,180), (180,0,270),
                                        (180,90,90), (180,90,180), (180,90,270),
                                        (180,180,90), (180,180,180), (180,180,270),
                                        (270,270,90), (270,270,180), (270,270,270),
                                        (270,0,90), (270,0,180), (270,0,270),
                                        (270,90,90), (270,90,180), (270,90,270)]

    function transform(a::Vector{Int}, α::Float64, β::Float64, γ::Float64)
        @assert length(a) == 3
        return [cos(β)*cos(γ)*a[1] + (sin(α)*sin(β)*cos(γ)-cos(α)*sin(γ))*a[2] + (cos(α)*sin(β)*cos(γ)+sin(α)*sin(γ))*a[3],
                cos(β)*sin(γ)*a[1] + (sin(α)*sin(β)*sin(γ)+cos(α)*cos(γ))*a[2] + (cos(α)*sin(β)*sin(γ)-sin(α)*cos(γ))*a[3],
                -sin(β)*a[1]       +                      (sin(α)*cos(β))*a[2] +                      (cos(α)*cos(β))*a[3]]
    end

    function transform_all(a::Vector{Int})
        
    end
end

