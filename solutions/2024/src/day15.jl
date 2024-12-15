module Day15
    using ..AdventOfCode24

    """
        day15()

    Solves the two puzzles of day 15. 
    """

    function day15(input::String = readInput(15))
        wh, op = split(input, "\n\n")
        lines = split(wh)
        op = prod(split(op))
        grid = [lines[i][j] for i in eachindex(lines), j in eachindex(lines[1])]

        robot = findfirst(==('@'), grid)
        boxes = findall(==('O'), grid)
        walls = findall(==('#'), grid)

        robot2 = CartesianIndex(robot, 0)
        boxes2 = Tuple.(zip(CartesianIndex.(boxes, 0), CartesianIndex.(boxes, 1)))
        walls2 = CartesianIndex.(walls, 0) ∪ CartesianIndex.(walls, 1)

        for o in op
            d = directions[o]
            robot = move_robot(robot, d, boxes, walls)

            d = directions2[o]
            robot2 = move_robot(robot2, d, boxes2, walls2)
        end

        s0 = score(boxes)
        s1 = score(boxes2)

        return [s0, s1]

    end

    import Base.+
    +(a::CartesianIndex{3}, b::CartesianIndex{3}) = CartesianIndex{3}(a[1]+b[1], a[2]+b[2] + sign(b[3]) * Int(a[3] == b[3] || a[3]+b[3] == -1), mod(a[3]+b[3],2))

    const directions = Dict('>' => CartesianIndex(0, 1), '<' => CartesianIndex(0, -1), '^' => CartesianIndex(-1, 0), 'v' => CartesianIndex(1, 0))
    const directions2 = Dict('>' => CartesianIndex(0, 0, 1), '<' => CartesianIndex(0, 0, -1), '^' => CartesianIndex(-1, 0, 0), 'v' => CartesianIndex(1, 0, 0))

    function move_robot(robot::CartesianIndex{2}, d::CartesianIndex{2}, boxes::Vector{CartesianIndex{2}}, walls::Vector{CartesianIndex{2}})
        next = robot + d

        if next in walls
            return robot

        elseif next in boxes
            move_boxes(next, d, boxes, walls) ? (return next) : (return robot)
        else
            return next
        end
    end

    function move_boxes(next::CartesianIndex{2}, d::CartesianIndex{2}, boxes::Vector{CartesianIndex{2}}, walls::Vector{CartesianIndex{2}})

        next_box = next + d

        if next_box in walls 
            return false
        elseif next_box in boxes
            !move_boxes(next_box, d, boxes, walls) && return false
        end
        
        i = findfirst(==(next), boxes)
        boxes[i] += d
        return true

    end

    function move_robot(robot::CartesianIndex{3}, d::CartesianIndex{3}, boxes::Vector{Tuple{CartesianIndex{3},CartesianIndex{3}}}, walls::Vector{CartesianIndex{3}})
        next = robot + d
        
        if next in walls
            return robot
        elseif any(in.(next, boxes))
            iboxes = move_boxes(next, d, boxes, walls) 

            isnothing(iboxes) && (return robot)

            for (i, b) in iboxes
                boxes[i] = b
            end

            return next

        else
            return next
        end

    end

    function move_boxes(next::CartesianIndex{3}, d::CartesianIndex{3}, boxes::Vector{Tuple{CartesianIndex{3},CartesianIndex{3}}}, walls::Vector{CartesianIndex{3}})

        i = findfirst(in.(next, boxes))
        box = boxes[i]
        next_boxes = (box[1]+d, box[2]+d)

        x = []
        for b in next_boxes

            if b in walls 
                return 
            elseif !(b in box) && any(in.(b, boxes))
                iboxes = move_boxes(b, d, boxes, walls)
                isnothing(iboxes) && return
                union!(x, iboxes)
            end

        end

        return union!(x, [(i, next_boxes)])

    end

    function score(boxes::Vector{CartesianIndex{2}})
        s = 0
        for b in boxes
            s += 100*(b[1]-1)+(b[2]-1)
        end

        return s
    end

    function score(boxes::Vector{Tuple{CartesianIndex{3}, CartesianIndex{3}}})
        s = 0
        for (b,_) in boxes
            s += 100*(b[1]-1)+2*(b[2]-1)+b[3]
        end

        return s
    end
        
end 