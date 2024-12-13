module Day13
    using ..AdventOfCode24

    """
        day13()

    Solves the two puzzles of day 13. 
    """

    function day13(input::String = readInput(13))
        r = r"""Button A: X\+(\d+), Y\+(\d+)
            Button B: X\+(\d+), Y\+(\d+)
            Prize: X=(\d+), Y=(\d+)"""

        s0 = 0
        s1 = 0

        for m in eachmatch(r, input)

            a11, a21, a12, a22, b1, b2 =  parse.(Int, m.captures)

            s0 += solve_matrix(a11, a21, a12, a22, b1, b2)

            b1 += 10000000000000
            b2 += 10000000000000
            s1 += solve_matrix(a11, a21, a12, a22, b1, b2)
        end

        return [s0, s1]
    end



    function solve_matrix(a11::Int, a21::Int, a12::Int, a22::Int, b1::Int, b2::Int)
        det = a11 * a22 - a12 * a21

        c1, r1 = divrem(a22 * b1 - a12 * b2, det)
        c2, r2 = divrem(a11 * b2 - a21 * b1, det)

        (r1 != 0 || r2 != 0) && return 0

        return 3 * Int(c1) + Int(c2)
    end


end 

