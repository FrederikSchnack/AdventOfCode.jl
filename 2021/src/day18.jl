module Day18
    using ..AdventOfCode21

    """
        day18()

    Solves the two puzzles of day 18. 
    """
    abstract type Node end

    mutable struct Leaf <: Node
        parent::Union{Nothing, Node}
        value::Int
    end

    mutable struct Branch <: Node
        parent::Union{Nothing, Node}
        left::Union{Nothing, Node, Leaf}
        right::Union{Nothing, Node, Leaf}
    end

    function Branch(s::AbstractString, parent::Union{Nothing, Branch} = nothing)
        all(isnumeric, s) && return Leaf(parent, parse(Int, s))
        c = 0
        for k in eachindex(s)
            if s[k] == '['
                c += 1
            elseif s[k] == ']'
                c -= 1
            end

            if c == 1 && s[k] == ','
                c = k
                break  
            end
        end
        
        newBranch = Branch(parent, nothing, nothing)
        newBranch.left = Branch(s[2:c-1], newBranch)
        newBranch.right = Branch(s[c+1:end-1], newBranch)

        return newBranch 
    end

    mutable struct Tree
        root::Node
    end

    function Tree(s::AbstractString)
        return Tree(Branch(s))
    end

    function generate_string(s::Branch)
            left = generate_string(s.left)
            right = generate_string(s.right) 
        return "["*left*","*right*"]"
    end

    function generate_string(s::Leaf)
        return string(s.value)
    end

    Base.show(io::IO, s::Tree) = print(io, generate_string(s.root))
    Base.show(io::IO, s::Branch) = print(io, generate_string(s))


    function first_leaf(node::Node)
        node isa Leaf && return node
        return first_leaf(node.left)
    end

    function last_leaf(node::Node)
        node isa Leaf && return node
        return last_leaf(node.right)
    end

    function prev_leaf(node::Node)
        isnothing(node.parent) && return nothing

        if node.parent.left == node
            return prev_leaf(node.parent)
        else
            return last_leaf(node.parent.left)
        end
    end

    function next_leaf(node::Node)
        isnothing(node.parent) && return nothing

        if node.parent.right == node
            return next_leaf(node.parent)
        else
            return first_leaf(node.parent.right)
        end
    end



    function explosive_node(s::Node, depth::Int = 0)
        s isa Leaf && return nothing
        depth == 4 && return s

        left = explosive_node(s.left, depth+1)
        isnothing(left) && return explosive_node(s.right, depth+1)
        return left
    end

    function explode!(s::Node)
        prev = prev_leaf(s)
        if !isnothing(prev)
            prev.value += s.left.value
        end

        next = next_leaf(s)
        if !isnothing(next)
            next.value += s.right.value
        end

        if s.parent.left == s
            s.parent.left = Leaf(s.parent, 0)
        elseif s.parent.right == s
            s.parent.right = Leaf(s.parent, 0)
        end

    end

    function explode!(s::Tree)
        exp = explosive_node(s.root)
        isnothing(exp) && return false
        explode!(exp)
        return true
    end

    function new_split(s::Int)
        return floor(Int, s/2), ceil(Int, s/2)
    end

    function split_node(s::Node)
        if s isa Leaf 
            s.value ≥ 10 && return s
            return nothing
        end

        left = split_node(s.left)
        left isa Leaf && return left

        right = split_node(s.right)
        right isa Leaf && return right

        return nothing
    end

    function split!(spl::Leaf)
        a,b = new_split(spl.value)
        newBranch = Branch(spl.parent, nothing, nothing)
        newBranch.left = Leaf(newBranch, a)
        newBranch.right = Leaf(newBranch, b)

        if spl == spl.parent.left
            spl.parent.left = newBranch
        elseif spl == spl.parent.right
            spl.parent.right = newBranch
        end
    end

    function split!(s::Tree)
        spl = split_node(s.root)
        isnothing(spl) && return false
        split!(spl)
        return true
    end

    function reduce!(s::Tree)
        while true
            explode!(s) && continue
            split!(s) && continue
            break
        end
    end

    function magnitude(s::Node)
        s isa Leaf && return s.value
        return 3 * magnitude(s.left) + 2*magnitude(s.right)
    end

    function magnitude(s::Tree)
        return magnitude(s.root)
    end

    function add(a::Tree, b::Tree)
        root = Branch(nothing, nothing, nothing)

        root.left = a.root
        root.left.parent = root 

        root.right = b.root
        root.right.parent = root 
        return Tree(root)
    end

    function Base.:+(a::Tree, b::Tree)
        tree = add(a, b)
        reduce!(tree)
        return tree
    end

    function Base.:+(a::Tree, b::Nothing)
        return a
    end

    function Base.:+(a::Nothing, b::Tree)
        return b
    end

    function day18(input::String = readInput(18))
        snail = Tree[]
        for l in split(input, "\n")
            push!(snail, Tree(l))
        end
        snail0 = deepcopy(snail)
        s0 = magnitude(sum(snail0))

        s1 = 0
        for (a,b) in Iterators.product(snail, snail)
            if a != b
                mag1 = magnitude(deepcopy(a)+deepcopy(b))
                mag2 = magnitude(deepcopy(b)+deepcopy(a))
                s1 = max(s1, mag1, mag2)
            end
        end

        return [s0, s1]
    end
end