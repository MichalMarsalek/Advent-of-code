include aoc

day 5:
    var p1, p2: CountTable[(int,int)]
    for line in lines:
        var (ok, x1, y1, x2, y2) = line.scanTuple("$i,$i -> $i,$i")
        for i in 0..max(max(x1, x2)-min(x1, x2),max(y1, y2)-min(y1, y2)):
            let X = x1 + i * sgn(x2-x1)
            let Y = y1 + i * sgn(y2-y1)
            if x1 == x2 or y1 == y2:
                p1.inc (X,Y)
            p2.inc (X,Y)
    part 1: p1.keys.countIt (p1[it] > 1)
    part 2: p2.keys.countIt (p2[it] > 1)