
module Day25

using ..AdventOfCode22

"""
    day25()

Solves the two puzzles of day 25. 
"""
function day25(input::String = readInput(25))
    sn = 0

    for line in split(input, '\n')
        sn += to_dec(line)
    end

    return to_snafu(sn)
end


function to_dec(sn::AbstractString)
    dec = 0

    for (i,s) in enumerate(sn[end:-1:1])
        val = 5^(i-1)

        if s == '-'
            val *= -1
        elseif s == '='
            val *= -2
        else
            val *= parse(Int, s)
        end

        dec += val
    end

    return dec
end

function to_snafu(dec::Int)
    sn = ""

    rn = dec
    max = 99
    it = 1
    while rn !== 0 && it < 100
        if rn > 0 
            rn, ln, s = check_lead_pos(rn, max)
        else
            rn, ln, s = check_lead_neg(rn, max)
        end

        if max - ln -1 > 0 && it > 1
            sn *= '0'^(max-ln-1)
        end

        max = ln 

        sn *= s
        it += 1
    end

    sn *= '0'^max

    return sn
end


function check_lead_pos(dec::Int, max::Int)
    ln = 0
    while dec -  5^ln + 2* sum(5 .^(0:ln-1))  ≥ 0 && ln < max
        ln += 1 
    end
    (ln > 0) && (ln -= 1)

    if dec - 2 * 5^ln + 2* sum(5 .^(0:ln-1)) ≥ 0
        return (dec - 2 * 5^ln, ln, '2')
    elseif dec - 5^ln + 2* sum(5 .^(0:ln-1)) ≥ 0
        return  (dec - 5^ln, ln, '1')
    else
        return (dec, ln, '0')
    end
end

function check_lead_neg(dec::Int, max::Int)
    ln = 0
    while dec +  5^ln - 2* sum(5 .^(0:ln-1))  ≤ 0 && ln < max
        ln += 1 
    end
    (ln > 0) && (ln -= 1)

    if dec + 2 * 5^ln - 2* sum(5 .^(0:ln-1)) ≤ 0
        return (dec + 2 * 5^ln, ln, '=')
    elseif dec + 5^ln - 2* sum(5 .^(0:ln-1)) ≤ 0
        return  (dec + 5^ln, ln, '-')
    else
        return (dec, ln, '0')
    end
end

end # module