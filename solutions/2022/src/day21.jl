
module Day21

using ..AdventOfCode22

"""
    day21()

Solves the two puzzles of day 21.
"""
function day21(input::String = readInput(21))
    numbers = Dict{String, Int}()
    monkeys = Dict{String, Tuple{String, String, String}}()

    for line in split(input, "\n")
        spl = split(line, " ")

        if length(spl) > 2
            monkeys[spl[1][1:end-1]] = (spl[2], spl[3], spl[4])
        else
            numbers[spl[1][1:end-1]] = parse(Int, spl[2])
        end
    end

    numbers2 = deepcopy(numbers)
    monkeys2 = deepcopy(monkeys)

    while "root" in keys(monkeys)
        resolve_step!(numbers, monkeys)
    end

    s0 = numbers["root"]

    human = Tuple{String, String, Int}[]
    delete!(numbers2, "humn")

    while  length(monkeys2) > 0
        resolve_step!(numbers2, monkeys2)
        check_human!(human, numbers2, monkeys2)
    end

    s1 = backtrack(human)

    return [s0, s1]
end

function resolve_step!(numbers::Dict{String, Int}, monkeys::Dict{String, Tuple{String, String, String}})
    for (name, (left, op, right)) in monkeys
        if left ∈ keys(numbers) && right ∈ keys(numbers)
            
            if op == "+"
                numbers[name] = numbers[left] + numbers[right]
            elseif op == "-"
                numbers[name] = numbers[left] - numbers[right]
            elseif op == "*"
                numbers[name] = numbers[left] * numbers[right]
            else #op == "/"
                numbers[name] = numbers[left] // numbers[right]
            end
            delete!(monkeys, name)

        end
    end
end

function check_human!(human::Vector{Tuple{String, String, Int}}, numbers::Dict{String, Int}, monkeys::Dict{String, Tuple{String, String, String}})
    for (name, (left, op, right)) in monkeys
        if left == "humn" && right ∈ keys(numbers)

            push!(human, ("left", op, numbers[right]))
            replace_name!(name, monkeys)
        elseif right == "humn" && left ∈ keys(numbers)

            push!(human, ("right", op, numbers[left]))
            replace_name!(name, monkeys)
        end

    end
end

function replace_name!(new_name::String, monkeys::Dict{String, Tuple{String, String, String}})
    for (name, (left, op, right)) in monkeys
        if left == new_name
            monkeys[name] = ("humn", op, right)
        end
        if right == new_name
            monkeys[name] = (left, op, "humn")
        end
    end
    delete!(monkeys, new_name)
end

function backtrack(human::Vector{Tuple{String, String, Int64}})
    val = human[end][3]

    for t in human[end-1:-1:1]

        lr, op, num = t
        if op == "+"
            val -= num
        elseif op == "-"
            lr =="left" ? (val += num) : (val = num - val)
        elseif op == "*"
            val //= num
        else #op == "/"
            lr =="left" ? (val *= num) : (val = num//val)
        end
    end

    return Int(val)
end
end # module