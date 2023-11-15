module Day07

    using ..AdventOfCode22

    """
        day07()

    Solves the two puzzles of day 7. 
    """
    mutable struct Directory
        name::String
        parent::Union{Directory, Nothing}
        children::Dict{String, Directory}
        size::Int
    end

    function day07(input::String = readInput(7))
        root = Directory("/", nothing, Dict(), 0)
        current = root

        for str in split(input, "\n")[3:end]    
            if startswith(str, '$')
                if startswith(str[3:end], "cd")
                    if str[6:end] == ".."
                        current = current.parent
                    elseif str[6:end] == "/"
                        current = root
                    else
                        current = current.children[str[6:end]]
                    end
                end
            else
                val, name = split(str, " ")
                if val == "dir"
                    current.children[name] = Directory(name, current, Dict(), 0)
                else
                    current.size += parse(Int, val)
                end
            end

        end

        size_list = Int[]
        calculate_sizes(root, size_list)
        th =  30000000 - (70000000 - root.size)

        s0 = sum(size_list[size_list .< 100000])
        s1 = minimum(size_list[size_list .≥ th])

        return [s0, s1]
    end

    function calculate_sizes(dir::Directory, vals::Vector{Int})
        dir.size += sum(map(x -> calculate_sizes(x, vals), values(dir.children)), init=0)
        push!(vals, dir.size)
        return dir.size
    end

end # module