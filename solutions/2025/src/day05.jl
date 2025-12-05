module Day05
    using ..AdventOfCode25

    """
        day05()

    Solves the two puzzles of day 05. 
    """

    function day05(input::String = readInput(05))
        
        s0 = 0
        
        ranges, ids = split(input, "\n\n")

        intervals = [Tuple(parse.(Int, r.captures)) for r in eachmatch(r"(\d+)-(\d+)", ranges)] |> sort!

        tree = Node(popat!(intervals, div(length(intervals),2)))

        while !isempty(intervals)
            add_Node!(tree, popat!(intervals, div(length(intervals),2)+1))
        end

        for id in split(ids) 
            check_included(tree, parse(Int, id)) && (s0 += 1)
        end

        s1 = sum_tree(tree)

        return [s0, s1]

    end

    mutable struct Node
        val::Tuple{Int, Int}
        left::Union{Node, Nothing}
        right::Union{Node, Nothing}

        Node(val::Tuple{Int, Int}) = new(val, nothing, nothing)
    end

    function add_Node!(node::Node, val::Tuple{Int, Int})
        if val[2] < node.val[1]
            isnothing(node.left) ? (node.left = Node(val)) : add_Node!(node.left, val)
        elseif val[1] > node.val[2]
            isnothing(node.right) ? (node.right = Node(val)) : add_Node!(node.right, val)
        else
            node.val = (min(node.val[1], val[1]), max(node.val[2], val[2]))
        end
    end

    function check_included(tree::Node, val::Int)
        if val < tree.val[1]
            isnothing(tree.left) ? (return false) : return check_included(tree.left, val)
        elseif val > tree.val[2]
            isnothing(tree.right) ? (return false) : return check_included(tree.right, val)
        else
            return true
        end
    end

    function sum_tree(tree::Node)
        s = tree.val[2] - tree.val[1] + 1
        isnothing(tree.left) || (s += sum_tree!(tree.left))
        isnothing(tree.right) || (s += sum_tree!(tree.right))
        return s
    end

end
    


