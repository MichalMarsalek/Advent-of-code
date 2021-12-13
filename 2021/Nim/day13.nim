include aoc

day 13:    
    var parts_0 = input.split("\n\n")
    var points: HashSet[Point]
    var folds: seq[Point]
    
    for L in parts_0[0].intgrid:
        points.incl (L[0],L[1])
    for L in parts_0[1].splitLines:
        if 'y' in L:
            folds.add (0, L.ints[0])
        else:
            folds.add (L.ints[0], 0)
    
    func fold(points: HashSet[Point], fold:Point): HashSet[Point] =
        for p in points:
            if fold.x == 0 and p.y > fold.y:
                result.incl (p.x, 2*fold.y - p.y)
            elif fold.y == 0 and p.x > fold.x:
                result.incl (2*fold.x - p.x, p.y)
            else:
                result.incl p
    part 1:
        points.fold(folds[0]).len
    part 2:
        for f in folds:
            points = points.fold(f)
        points.toSeq.plot
        