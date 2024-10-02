module Day13

    using ..AdventOfCode22

    """
        day13()

    Solves the two puzzles of day 13. 
    """
    function day13(input::String = readInput(13))
        lines = split(input, "\n")
        packets = Packet[]
        for l in lines
            if !isempty(l) 
                push!(packets, read_packet(l))
            end
        end

        s0 = 0
        for i in 1:2:length(packets)-1
            packets[i] < packets[i+1] && (s0 += (i+1)÷2)
        end

        d2, d6 = Packet([Packet([2])]), Packet([Packet([6])])
        push!(packets, d2, d6)
        sort!(packets)
        s1 = findfirst(x -> x == d2, packets) * findfirst(x -> x == d6, packets)

        return [s0, s1]
    end

    struct Packet
        list::Union{Vector{Union{Packet, Int}}}
    end

    function Base.isempty(p::Packet)
        return isempty(p.list)
    end

    function generate_string(p::Packet)
        if !isempty(p.list)
            return "["* prod(generate_string.(p.list) .* [["," for _ in 1:length(p.list)-1]..., ""] ) *"]"
        else
            return "[]"
        end
    end

    function generate_string(p::Int)
        return string(p)
    end

    Base.show(io::IO, z::Packet) = print(io, generate_string(z))

    function read_packet(l::AbstractString)
        list = Union{Int, Packet}[]
        count = 0
        curr_ind = 2

        if length(l) < 3
            return Packet(list)
        else
            for k in 2:length(l)-1
                if l[k] == '['
                    count += 1
                elseif l[k] == ']'
                    count -= 1
                end
                if count == 0

                    if l[k] == ']'
                        push!(list, read_packet(l[curr_ind:k]))
                        curr_ind = k+2
                    else
                        if isnumeric(l[k]) 
                            if (l[k+1] ∈ [',', '[', ']'] && l[k-1] ∈ [',', '[', ']'])
                                push!(list, parse(Int, l[k]))
                                curr_ind = k+2
                            elseif isnumeric(l[k+1])
                                push!(list, parse(Int, l[k:k+1]))
                                curr_ind = k+3
                            end
                        end
                    end

                end
            end
        end

        return Packet(list)
    end

    function compare(p1::Packet, p2::Packet)
        ind = min(length(p1.list), length(p2.list))
        for k in 1:ind
            res = compare(p1.list[k], p2.list[k]) 
            if !isnothing(res)
                return res 
            end
        end

        if ind < length(p1.list) 
             return false
        elseif ind < length(p2.list)
            return true
        end
    end

    function compare(p1::Int, p2::Int)
         if p1 < p2 
            return true
         elseif p1 > p2
            return false
         else
            return nothing
         end
    end

    function compare(p1::Int, p2::Packet)
        return compare(Packet([p1]), p2)
    end

    function compare(p1::Packet, p2::Int)
        return compare(p1, Packet([p2]))
    end

    function Base.isless(p1::Packet, p2::Packet)
        return compare(p1, p2)
    end

end # module