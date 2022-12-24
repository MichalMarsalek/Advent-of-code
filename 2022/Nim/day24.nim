include aoc

day 24:
    let w = lines[0].len - 2
    let h = lines.len - 2
    var valley0: DTable[Point, seq[Point]]
    for y, line in lines[1..^2]:
        for x, c in line[1..^2]:
            if c != '.':
                var z: seq[Point]
                valley0[(x, y)] = @[toDirection c]
    var valley = @[valley0]
    for i in 0..1000:
        var nt: DTable[Point, seq[Point]]
        for p, vs in valley[i]:
            for v in vs:
                var np = p + v
                np = (np.x.floorMod w, np.y.floorMod h)
                nt[np] &= v
        valley &= nt

    proc solve(start, goal: Point, time: int): int =
        var q = [(start, time)].toDeque
        var visited = [(start, time)].toHashSet
        while true:
            var (pos, time) = q.popFirst
            if pos == goal:
                return time + 1
            var neis = pos.neighbours(directions4).toSeq & pos
            for nei in neis:
                if nei == start or nei.x in 0..<w and nei.y in 0..<h and nei notin valley[time+1]:
                    if (nei, time+1) notin visited:
                        q.addLast (nei, time+1)
                        visited.incl (nei, time+1)

    var time = solve((0, -1), (w-1, h-1), 0)
    part 1: time
    part 2:
        time = solve((w-1, h), (0, 0), time)
        time = solve((0, -1), (w-1, h-1), time)
        time
