module Day10
    using ..AdventOfCode25
    using JuMP, HiGHS
    """
        day10()

    Solves the two puzzles of day 10. 
    """

    function day10(input::String = readInput(10))
        
        s0 = 0
        s1 = 0
        for l in split(input, "\n")
            slots = match(r"\[(\W+)\]", l).captures[1]

            b = [ c.captures[1] for c in eachmatch(r"(?:\((\d+(?:\,?\d+)*)\))+", l)]
            buttons = [zeros(Int, length(slots)) for _ in 1:length(b)]
            for (i, bb) in enumerate(split.(b, ','))
                buttons[i][parse.(Int, bb).+1] .= 1
            end

            c = match(r"{(\d+(?:\,?\d+)*)}", l).captures[1]
            joltage = parse.(Int, split(c, ',')) 

            s0 += push_buttons(slots, buttons)
            s1 += solve_system(buttons, joltage)
        end

        return [s0, s1]
    end


    function push_buttons(slots::AbstractString, buttons::Vector{Vector{Int}})
        n = length(slots)

        goal = zeros(Int, n)
        goal[findall(==('#'), slots)] .= 1

        m = length(buttons)

        state = zeros(Int, n)
        queue = [state]
        visited = Dict{Vector{Int}, Int}(state => 0) 

        while !isempty(queue) 
            state = popfirst!(queue)
            v = visited[state]+1

            for i in 1:m

                new_state = xor.(buttons[i], state)

                if !(new_state in keys(visited))
        
                    (new_state == goal) && (return v)
                    visited[new_state] = v
                    push!(queue, new_state)
                end

            end

        end
    end

    function solve_system(buttons::Vector{Vector{Int}}, joltage::Vector{Int})
        m = length(buttons)
        n = length(joltage)

        model = Model(HiGHS.Optimizer)
        set_silent(model)
        @variable(model, x[1:m] >= 0, Int)
        @objective(model, Min, sum(x))
        for j in 1:n
            @constraint(model, sum(buttons[i][j]*x[i] for i in 1:m) == joltage[j] )
        end
        optimize!(model)
        assert_is_solved_and_feasible(model)
        
        return round(Int, objective_value(model))
    end

end  