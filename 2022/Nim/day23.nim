include aoc

day 23:
    var elves: HashSet[Point]
    var grid = lines.mapIt(it.toSeq)
    for p, v in grid:
        if v == '#':
            elves.incl p

    var dirs = @[
        ((-1, -1), (0, -1), (1, -1)),
        ((1, 1), (0, 1), (-1, 1)),
        ((-1, 1), (-1, 0), (-1, -1)),
        ((1, -1), (1, 0), (1, 1)),
    ]
    var moved = true
    proc step(elves: HashSet[Point]): HashSet[Point] =
        result = elves
        var propositions: Table[Point, seq[Point]]
        for elve in elves:
            if elve.neighbours(directions8).toSeq.anyIt(it in elves):
                for (a, b, c) in dirs:
                    if (a+elve) notin elves and (b+elve) notin elves and (c+elve) notin elves:
                        if (b+elve) notin propositions:
                            propositions[b+elve] = @[]
                        propositions[b+elve].add elve
                        break
        moved = false
        for dest, sources in propositions:
            if sources.len == 1:
                result.excl sources[0]
                result.incl dest
                moved = true
        dirs = dirs[1..3] & dirs[0]
    var elvesAfter10: HashSet[Point]
    var i = 0
    while moved:
        elves = step elves
        inc i
        if i == 10:
            elvesAfter10 = elves

    part 1, int:
        let minX = elvesAfter10.map(x).toSeq.min
        let maxX = elvesAfter10.map(x).toSeq.max
        let minY = elvesAfter10.map(y).toSeq.min
        let maxY = elvesAfter10.map(y).toSeq.max
        for x in minX..maxX:
            for y in minY..maxY:
                result += int((x, y) notin elvesAfter10)
    part 2, int:
        i

