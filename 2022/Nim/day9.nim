include aoc

day 9:
    proc simulate(movements: seq[(Point, int)], length: int): int =
        var tailVisited: HashSet[Point]
        tailVisited.incl (0, 0)
        var rope = newSeq[Point](length)
        for (dir, am) in movements:
            for _ in 1..am:
                rope[0] += dir
                for i in 1..<rope.len:
                    if distMax(rope[i], rope[i-1]) > 1:
                        rope[i] += map(rope[i-1] - rope[i], sgn)
                tailVisited.incl rope[^1]
        card tailVisited

    let movements = collect:
        for line in lines:
            var (_, d, am) = line.scanTuple"$w $i"
            (toDirection d, am)
    part 1: movements.simulate 2
    part 2: movements.simulate 10
