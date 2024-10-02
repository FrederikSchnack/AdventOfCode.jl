
module Day20

using ..AdventOfCode22

"""
    day20()

Solves the two puzzles of day 20. 
"""
function day20(input::String = readInput(20))
    lines = split(input, "\n")
    n = length(lines)
    v = Vector{LinkedList}(undef, n)
    ind0 = 1

    v[1] = LinkedList(parse(Int, lines[1]), nothing, nothing)

    for k in 2:n
        val = parse(Int, lines[k])
        v[k] = LinkedList(val, v[k-1], nothing) 
        val == 0 && (ind0 = k)
    end

    v[1].prev = v[n]
    v[n].next = v[1]
    
    for k in 1:n-1
        v[k].next = v[k+1]
    end
    
    vv = deepcopy(v)

    shuffle!(v)
    s0 = get_groove(v[ind0], n)

    key = 811589153 
    for _ in 1:10
        shuffle!(vv, key)
    end
    s1 = get_groove(vv[ind0], n)*key

    return [s0, s1]
end

mutable struct LinkedList
    val::Int
    prev::Union{Nothing, LinkedList}
    next::Union{Nothing, LinkedList}
end

Base.show(io::IO, z::LinkedList) = print(io, (z.val, z.prev.val, z.next.val))

function shuffle!(list::Vector{LinkedList}, key::Int = 1)
    n = length(list)
    for elem in list
        move!(elem, n, elem.val * key)
    end
end

function move!(src::LinkedList, cap::Int, id::Int)
    n = mod(id, cap - 1)
    n == 0 && return 

    src.prev.next = src.next
    src.next.prev = src.prev

    prev = src
    for _ in 1:n
        prev = prev.next
    end

    next = prev.next
    prev.next = src
    next.prev = src

    src.prev = prev
    src.next = next
end

function get_groove(zero::LinkedList, n::Int)
    nsteps = mod(1000, n)

    s0 = 0
    for _ in 1:3
        for _ in 1:nsteps
            zero = zero.next
        end
        s0 += zero.val
    end

    return s0
    
end

end # module