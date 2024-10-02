
module Day19

    using ..AdventOfCode22

    """
        day19()

    Solves the two puzzles of day 19. 
    """
    function day19(input::String = readInput(19))
        blueprints = Dict{Int, BluePrint}()
        for line in split(input, "\n")
            regex = r"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."
            id, o_o, c_o, ob_o, ob_c, g_o, g_ob = parse.(Int, match(regex, line).captures)
            blueprints[id] = BluePrint(o_o, c_o, (ob_o, ob_c), (g_o, g_ob))
        end 


        s0 = 0
        for (id, b) in blueprints
            score = do_step(b)
            s0 += id * score
        end

        s1 = 1
        for i in 1:3
            st = Dict{Tuple{Tuple{Int, Int, Int}, Tuple{Int, Int, Int}, Int}, Int}()
            s1 *= do_step(blueprints[i], st, (0, 0, 0), (1, 0, 0), 32 )
        end

        return [s0,s1]
    end
     
    struct BluePrint
        ore::Int
        clay::Int
        obsidian::Tuple{Int, Int}
        geode::Tuple{Int, Int}
    end

    function do_step(bp::BluePrint, states::Dict{Tuple{Tuple{Int, Int, Int}, Tuple{Int, Int, Int}, Int}, Int} = Dict{Tuple{Tuple{Int, Int, Int}, Tuple{Int, Int, Int}, Int}, Int}(), res::Tuple{Int, Int, Int} = (0,0,0), robots::Tuple{Int, Int, Int}=(1,0,0), timeleft::Int = 24)
        if (res, robots, timeleft) ∈ keys(states)
            return states[(res, robots, timeleft)]
        end
        
        if timeleft ≤ 1
            states[(res, robots, timeleft)] = 0
            return 0
        end

        max_dor = Int(ceil((max(bp.ore, bp.clay, bp.obsidian[1], bp.geode[1]) * timeleft - res[1]) / timeleft))
        max_dcl = Int(ceil((bp.obsidian[2] * timeleft - res[2]) / timeleft))
        max_dob = Int(ceil((bp.geode[2] * timeleft - res[3]) / timeleft))

        need_or = robots[1] < max_dor
        need_cl = robots[2] < max_dcl
        need_ob = robots[3] < max_dob
        
        build_ge = (res[1] >= bp.geode[1] && res[3] >= bp.geode[2])
        build_ob = (res[1] >= bp.obsidian[1] && res[2] >= bp.obsidian[2] && need_ob)
        build_cl = (res[1] >= bp.clay && need_cl && need_ob)
        build_or = (res[1] >= bp.ore && need_or)

        score = 0

        if build_ge
            resources_ = (res[1] + robots[1] - bp.geode[1], res[2] + robots[2], res[3] + robots[3] - bp.geode[2])
            score = max(score, do_step(bp, states, resources_, robots, timeleft-1) + timeleft - 1)
        else
            if build_ob
                resources_ = (res[1] + robots[1] - bp.obsidian[1], res[2] + robots[2] - bp.obsidian[2], res[3] + robots[3])
                score = max(score, do_step(bp, states, resources_, (robots[1], robots[2], robots[3] + 1), timeleft-1))
            end
                
            if build_or
                resources_ = (res[1] + robots[1] - bp.ore, res[2] + robots[2], res[3] + robots[3])
                score = max(score, do_step(bp, states, resources_, (robots[1] + 1, robots[2], robots[3]), timeleft-1))
            end

            if build_cl
                resources_ = (res[1] + robots[1] - bp.clay, res[2] + robots[2], res[3] + robots[3])
                score = max(score, do_step(bp, states, resources_, (robots[1], robots[2] + 1, robots[3]), timeleft-1))
            end

                resources_ = (res[1] + robots[1], res[2] + robots[2], res[3] + robots[3])
                score = max(score, do_step(bp, states, resources_, robots, timeleft-1))            
        end

        states[(res, robots, timeleft)] = score

        return score
    end


end # module