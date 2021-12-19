include aoc

day 5:
    var p1, p2: CountTable[Point]
    for line in lines:
        var (x1, y1, x2, y2) = line.ints4
        for i in 0..max(abs(x1-x2),abs(y1-y2)):
            let P = (x1,x2) + i * (sgn(x2-x1), sgn(y2-y1))
            if x1 == x2 or y1 == y2:
                p1.inc P
            p2.inc P
    part 1: p1.keys.countIt (p1[it] > 1)
    part 2: p2.keys.countIt (p2[it] > 1)