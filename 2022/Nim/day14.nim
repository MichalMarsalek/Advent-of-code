include aoc

day 14:
    let groups = lines.mapIt(it.split(" -> ").map ints2)
    var world: HashSet[Point]
    for group in groups:
        for (a, b) in zip(group, group[1..^1]):
            var a = a
            let d = map(b-a, sgn)
            while a != b:
                world.incl a
                a += d
            world.incl b
    let lowest = world.toSeq.map(y).max

    func simulate(world: HashSet[Point]): int =
        ## Ruturns the number of sand units produced until an infinite fall
        ## or there's no more room
        var world = deepCopy world
        let lowest = world.toSeq.map(y).max
        for round in 0..int.high:
            var sand = (500, 0)
            if sand in world:
                return round
            while true:
                if sand.y > lowest:
                    return round
                if (sand + (0, 1)) notin world:
                    sand += (0, 1)
                elif (sand + (-1, 1)) notin world:
                    sand += (-1, 1)
                elif (sand + (1, 1)) notin world:
                    sand += (1, 1)
                else:
                    world.incl sand
                    break
    part 1:
        simulate(world)
    part 2:
        for x in -1000..1000:
            world.incl (x, lowest + 2)
        simulate(world)
