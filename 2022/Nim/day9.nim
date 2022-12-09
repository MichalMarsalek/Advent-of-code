include aoc

day 9:
    proc simulate(movements: seq[(Point, int)], length: int): int =
        var tailVisited: HashSet[Point]
        tailVisited.incl (0, 0)
        var rope = newSeq[Point](length)
        for (dir, am) in movements:
            for _ in 1..am:
                rope[0] = rope[0] + dir
                for i in 1..<rope.len:
                    let newPos = rope[i] + (sgn(rope[i-1].x-rope[i].x), sgn(rope[i-1].y-rope[i].y))
                    if newPos != rope[i-1]:
                        rope[i] = newPos
                tailVisited.incl rope[^1]
        card tailVisited

    let movements = collect:
        for line in lines:
            var (_, d, am) = line.scanTuple"$w $i"
            (toTable({"U": (0, -1), "D": (0, 1), "R": (1, 0), "L": (-1, 0)})[d], am)
    part 1: movements.simulate 2
    part 2: movements.simulate 10
