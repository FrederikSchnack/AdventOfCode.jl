
module Day22

using ..AdventOfCode22

"""
    day22()

Solves the two puzzles of day 22. 
"""
function day22(input::String = readInput(22))
    lines = split(input, "\n")
    n = maximum(length.(lines[1:end-2]))

    ver_bd = Dict{Int, Tuple{Int, Int}}()
    hor_bd = Dict{Int, Tuple{Union{Nothing, Int}, Union{Nothing, Int}}}() 

    walls = CartesianIndex{2}[]
    prev_line = " "^n
    next_line = lines[2]
    for (i, line) in enumerate(lines[1:end-2])
        min = findfirst(collect(line) .!== ' ')
        max = findlast(collect(line) .!== ' ')
        ver_bd[i] = (min, max)

        for j in min:max
            if line[j] == '#'
                push!(walls, CartesianIndex(i, j))
            end

            if prev_line[j] == ' ' 
                haskey(hor_bd, j) ? hor_bd[j] = (i, hor_bd[j][2]) : hor_bd[j] = (i, nothing)
            elseif next_line[j] == ' '
                haskey(hor_bd, j) ? hor_bd[j] = (hor_bd[j][1], i) : hor_bd[j] = (nothing, i)
            end
        end

        prev_line = line * " "^(n-length(line))

        if i < n-2
            next_line = lines[i+2] * " "^(n-length(lines[i+2]))
        else
            next_line = " "^length(lines[1])
        end
    end

    pos1 = CartesianIndex(1, ver_bd[1][1])
    dir1 = 3
    pos2 = CartesianIndex(1, ver_bd[1][1])
    dir2 = 3

    inst = 'R'*lines[end]
    curr_ind = 1
    paths = [pos2]
    for val_st in split(inst, ['L','R'], keepempty=false)
        
        val = parse(Int, val_st)
        op = inst[curr_ind]
        dir1 = get_dir(dir1, op)
        dir2 = get_dir(dir2, op)

        #standard
        for _ in 1:val
            if dir1 == 0
                pos1[2] == ver_bd[pos1[1]][2] ? (pos_ = CartesianIndex(pos1[1], ver_bd[pos1[1]][1])) : (pos_ = CartesianIndex(pos1[1], pos1[2]+1))
                pos_ ∈ walls ? (break) : pos1 = pos_

            elseif dir1 == 2
                pos1[2] == ver_bd[pos1[1]][1] ? (pos_ = CartesianIndex(pos1[1], ver_bd[pos1[1]][2])) : (pos_ = CartesianIndex(pos1[1], pos1[2]-1))
                pos_ ∈ walls ? (break) : pos1 = pos_

            elseif dir1 == 1
                pos1[1] == hor_bd[pos1[2]][2] ? (pos_ = CartesianIndex(hor_bd[pos1[2]][1], pos1[2])) : (pos_ = CartesianIndex(pos1[1]+1, pos1[2]))
                pos_ ∈ walls ? (break) : pos1 = pos_

            else dir1 == 3
                pos1[1] == hor_bd[pos1[2]][1] ? (pos_ = CartesianIndex(hor_bd[pos1[2]][2], pos1[2])) : (pos_ = CartesianIndex(pos1[1]-1, pos1[2]))
                pos_ ∈ walls ? (break) : pos1 = pos_

            end
        end

        #cube
        for _ in 1:val
            if dir2 == 0
                pos2[2] == ver_bd[pos2[1]][2] ? ((pos_, dir_) = get_cont(pos2, dir2)) : (pos_ = CartesianIndex(pos2[1], pos2[2]+1); dir_ = dir2)
                pos_ ∈ walls ? (break) : (pos2 = pos_; dir2 = dir_)

            elseif dir2 == 2
                pos2[2] == ver_bd[pos2[1]][1] ? ((pos_, dir_) = get_cont(pos2, dir2)) : (pos_ = CartesianIndex(pos2[1], pos2[2]-1); dir_ = dir2)
                pos_ ∈ walls ? (break) : (pos2 = pos_; dir2 = dir_)

            elseif dir2 == 1
                pos2[1] == hor_bd[pos2[2]][2] ? ((pos_, dir_) = get_cont(pos2, dir2)) : (pos_ = CartesianIndex(pos2[1]+1, pos2[2]); dir_ = dir2)
                pos_ ∈ walls ? (break) : (pos2 = pos_; dir2 = dir_)

            else dir2 == 3
                pos2[1] == hor_bd[pos2[2]][1] ? ( (pos_, dir_) = get_cont(pos2, dir2)) : (pos_ = CartesianIndex(pos2[1]-1, pos2[2]); dir_ = dir2)
                pos_ ∈ walls ? (break) : (pos2 = pos_; dir2 = dir_)

            end
        end

        curr_ind += length(val_st)+1
        push!(paths, pos2)
    end

    s0 = 1000*pos1[1] + 4*pos1[2] + dir1
    s1 = 1000*pos2[1] + 4*pos2[2] + dir2

    return [s0, s1]
end

function get_dir(curr_dir::Int, op::Char)
    if curr_dir == 0
        op == 'R' ? (return 1) : (return 3)
    elseif curr_dir == 1
        op == 'R' ? (return 2) : (return 0)
    elseif curr_dir == 2
        op == 'R' ? (return 3) : (return 1)
    elseif curr_dir == 3
        op == 'R' ? (return 0) : (return 2)
    end
end

function get_cont(pos::CartesianIndex{2}, dir::Int)
    y,x = pos.I
    cube = "X"

    if y ≤ 50
        if x ≤ 100
            cube = "A"
        else 
            cube = "B"
        end
    elseif y ≤ 100
        cube = "C"
    elseif y ≤ 150
        if x ≤ 50
            cube = "D"
        else 
            cube = "E"
        end
    else
        cube = "F"
    end
    
    if cube == "A" 
        if dir == 2
            return CartesianIndex(151-y, 1), 0 
        elseif dir == 3
            return CartesianIndex(x+100, 1), 0 
        end
    elseif cube == "B" 
        if dir == 1
            return CartesianIndex(x-50, 100), 2 
        elseif dir == 0
            return CartesianIndex(151-y, 100), 2 
        elseif dir == 3
            return CartesianIndex(200, x-100), 3 
        end
    elseif cube == "C" 
        if dir == 0
            return CartesianIndex(50, y+50), 3 
        elseif dir == 2
            return CartesianIndex(101, y-50), 1 
        end
    elseif cube == "D" 
        if dir == 2
            return CartesianIndex(151-y, 51), 0
        elseif dir == 3
            return CartesianIndex(x+50, 51), 0
        end
    elseif cube == "E" 
        if dir == 0
            return CartesianIndex(151-y, 150), 2
        elseif dir == 1
            return CartesianIndex(x+100, 50), 2
        end
    elseif cube == "F"
        if dir == 0
            return CartesianIndex(150, y-100), 3
        elseif dir == 1
            return CartesianIndex(1, x+100), 1
        elseif dir == 2
            return CartesianIndex(1, y-100), 1
        end
    end 
end


end # module