module Day19
    using ..AdventOfCode23

    """
        day19()

    Solves the two puzzles of day 19. 
    """
    const Part = NTuple{4, Int}
    const Part_Range = NTuple{4, UnitRange}

    const WorkFlow = Tuple{Vector{Tuple{Char, Char, Int, AbstractString}}, AbstractString}


    const op = Dict{Char, Function}('<' => <, '>'=> >)

    const to_ind = Dict{Char, Int}('x' => 1, 'm' => 2, 'a' => 3, 's' => 4)


    function day19(input::String = readInput(19))
        workflows, parts = split(input, "\n\n")
        accepted = Set{Part}()

        rp = r"{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}"
        rw = r"(\w)([>|<])(\d+):(\w+)"
        rn = r"(\w+){.*,(\w+)}"

        wf = Dict{AbstractString, WorkFlow}()

        for w in split(workflows, "\n")

            e = Tuple{Char, Char, Int, AbstractString}[]
            for em in eachmatch(rw, w)
                push!(e, (em.captures[1][1], em.captures[2][1], parse(Int, em.captures[3]), em.captures[4]))
            end
            name, last = match(rn, w).captures

            wf[name] = (e, last)
        end

        ps = Set{Part}()
        for l in split(parts, "\n")
            push!(ps, Tuple(parse.(Int, match(rp, l).captures)))
        end

        for p in ps
             apply_workflow!("in",  p, wf, accepted)
        end

        s0 = sum(sum.(accepted))

        accepted = Set{Part_Range}()
        apply_workflow!("in", (1:4000, 1:4000, 1:4000, 1:4000), wf, accepted)

        s1 = map.( length, accepted) .|> prod |> sum

        return [s0, s1]
    end

    function apply_workflow!(name::AbstractString, p::Part, workflows::Dict{AbstractString, WorkFlow}, accepted::Set{Part})

        comm, next =  workflows[name]

        for (sym, ops, val, n) in comm

            if op[ops](p[to_ind[sym]], val)
                next = n
                break
            end
        end

        if next == "A"
            push!(accepted, p)
        elseif next != "R"
            apply_workflow!(next,  p, workflows, accepted)
        end

    end

    function apply_filter(p::Part_Range, i::Int, ops::Char, v::Int)

        tr = [p...]
        fa = copy(tr)

        if ops == '>'
            tr[i] = v+1:min(p[i].stop, 4000)
            fa[i] = max(p[i].start,1): v
        else
            fa[i] = v:min(p[i].stop, 4000)
            tr[i] = max(p[i].start,1): v-1
        end    
        return Tuple(tr), Tuple(fa)
    end

    function apply_workflow!(name::AbstractString, p::Part_Range, workflows::Dict{AbstractString, WorkFlow}, accepted::Set{Part_Range})
        comm, next =  workflows[name]

        ranges = p 
        for (sym, ops, val, n) in comm

            tr_range, fa_range = apply_filter(ranges, to_ind[sym], ops, val)
                
            if n == "A"
                push!(accepted, tr_range)
            elseif n != "R"
                apply_workflow!(n, tr_range, workflows, accepted)
            end

            ranges = fa_range
        end

        if next == "A"
            push!(accepted, ranges)
        elseif next != "R"
            apply_workflow!(next,  ranges, workflows, accepted)
        end
    end

end 


