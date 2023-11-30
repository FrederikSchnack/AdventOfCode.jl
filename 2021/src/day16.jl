module Day16
    using ..AdventOfCode21

    """
        day16()

    Solves the two puzzles of day 16. 
    """
    struct Packet
        version::Int
        type::Int
        value::Int
        subpackets::Vector{Packet}
    end
    
    function day16(input::String = readInput(16))
        raw = prod(string.(hex2bytes(input), base=2, pad = 8))

        packets = Vector{Packet}()
        
        parse_packet!(packets, raw, 1)

        s0 = sum_versions(packets)
        s1 = evaluate(packets[1])

        return [s0, s1]
    end

    function parse_packet!(packets::Vector{Packet}, raw::String, i::Int)

        (i > length(raw) || !contains(raw[i:end], '1')) && return i 
        version = bin_to_int(raw[i:i+2])
        type    = bin_to_int(raw[i+3:i+5])
        i += 6

        if type == 4
            values = ""

                while true
                    values *= raw[i+1:i+4]
                    raw[i] == '0' && (i += 5; break)
                    i+=5
                end

            push!(packets, Packet(version, type, bin_to_int(values), Vector{Packet}()))
        else
            id = raw[i]
            i += 1

            if id == '0'
                lim = bin_to_int(raw[i:i+14]) 
                i += 15
                lim += i
                p = Packet(version, type, id, Vector{Packet}())

                start = i
                while i < lim
                    i = parse_packet!(p.subpackets, raw, i)
                end

                push!(packets, p)

            else
                n = bin_to_int(raw[i:i+10])
                i += 11
                
                p = Packet(version, type, id, Vector{Packet}())

                for _ in 1:n
                    i = parse_packet!(p.subpackets, raw, i)
                end

                push!(packets, p)
            end

        end

        return i
    end

    bin_to_int(x::String) = parse(Int, x, base = 2)

    function sum_versions(packets::Vector{Packet})
        isempty(packets) && return 0

        return sum(p.version + sum_versions(p.subpackets) for p in packets)
    end

    function evaluate(packet::Packet)
        packet.type == 0 && return sum(evaluate(p) for p in packet.subpackets)
        packet.type == 1 && return prod(evaluate(p) for p in packet.subpackets)
        packet.type == 2 && return minimum(evaluate(p) for p in packet.subpackets)
        packet.type == 3 && return maximum(evaluate(p) for p in packet.subpackets)
        packet.type == 4 && return packet.value
        packet.type == 5 && return evaluate(packet.subpackets[1]) > evaluate(packet.subpackets[2]) ? 1 : 0
        packet.type == 6 && return evaluate(packet.subpackets[1]) < evaluate(packet.subpackets[2]) ? 1 : 0
        packet.type == 7 && return evaluate(packet.subpackets[1]) == evaluate(packet.subpackets[2]) ? 1 : 0
    end
end 