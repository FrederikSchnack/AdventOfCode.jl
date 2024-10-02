module Day11

    using ..AdventOfCode22

    """
        day11()

    Solves the two puzzles of day 11. 
    """
    function day11(input::String = readInput(11))
        monkeys_dict = Dict{Int, Monkey}()
        bigmonkeys_dict = Dict{Int, BigMonkey}()

        activity = Dict{Int, Int}()
        lcm = 1
        for m in split(input, "Monkey ", keepempty=false)
            mm = split(m, "\n")
            ind = parse(Int, mm[1][1])
            items = parse.(Int, split(mm[2], (':', ','))[2:end])
            op = split(mm[3])
            if op[end] == "old"
                operation = Tuple(op[end-2:end])
            else
                operation = Tuple((op[end-2], op[end-1], parse(Int, op[end])))
            end
            ops = x -> monkey_worry!(x, operation)

            next = Tuple(parse.(Int, [split(mm[j])[end] for j = 4:6]))
            lcm *= next[1]

            monkeys_dict[ind] = Monkey(items, next, ops, 0)
            bigmonkeys_dict[ind] = BigMonkey(items, next, ops, 0)
            activity[ind] = 0
        end

        n = length(monkeys_dict)
        monkeys = Monkeys(monkeys_dict)
        bigmonkeys = BigMonkeys(bigmonkeys_dict)

        for _ in 1:20
            for i in 0:n-1
                do_operation!(i, monkeys, true, lcm)
            end
        end
        s0 = prod(sort!([monkeys.monkeys[i].activity  for i in keys(monkeys.monkeys)])[end-1:end])

        for _ in 1:10000
            for i in 0:n-1
                do_operation!(i, bigmonkeys, false, lcm)
            end
        end
        s1 = prod(sort!([bigmonkeys.monkeys[i].activity  for i in keys(monkeys.monkeys)])[end-1:end])

        return [s0, s1]
    end
    
    mutable struct Monkey
        items::Vector{Int}
        next::Tuple{Int, Int, Int}
        op::Function
        activity::Int
    end

    struct Monkeys
        monkeys::Dict{Int, Monkey}
    end

    mutable struct BigMonkey
        items::Vector{BigInt}
        next::Tuple{Int, Int, Int}
        op::Function
        activity::Int
    end

    struct BigMonkeys
        monkeys::Dict{Int, BigMonkey}
    end

   

    function monkey_worry!(item::Union{Vector{Int}, Vector{BigInt}}, op::Tuple{AbstractString, AbstractString, Int})
        if op[2] == "*"   
             item .*= op[3]
        else
             item .+= op[3]
        end
    end

    function monkey_worry!(item::Union{Vector{Int}, Vector{BigInt}}, op::Tuple{AbstractString, AbstractString, AbstractString})
         item .^= 2
    end

    function do_operation!(i::Int, ms::Union{Monkeys, BigMonkeys}, worries::Bool, lcm::Int)
        m = ms.monkeys[i]
        m.activity += length(m.items)

        m.op(m.items)
        worries && (m.items .÷= 3) 
        test = isinteger.(m.items/m.next[1]) 
        m.items .%= lcm
        for k in eachindex(m.items)
            test[k] ? push!(ms.monkeys[m.next[2]].items, m.items[k]) : push!(ms.monkeys[m.next[3]].items, m.items[k])
        end
        
        empty!(m.items) 
    end

end # module