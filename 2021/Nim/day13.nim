include aoc

day 13:    
    var points: HashSet[Point]
    var folds: seq[Point]
    
    for L in lines:
        let p = L.ints
        if 'x' in L: folds.add (p[0], 0)
        if 'y' in L: folds.add (0, p[0])
        if ',' in L: points.incl (p[0], p[1])
    
    func fold(points: HashSet[Point], fold:Point): HashSet[Point] =
        func abs(p:Point): Point = (abs p.x, abs p.y)
        for p in points:
            result.incl abs(fold - abs(fold - p))
    part 1:
        points.fold(folds[0]).len
    part 2:
        for f in folds:
            points = points.fold(f)
        points.toSeq.plot