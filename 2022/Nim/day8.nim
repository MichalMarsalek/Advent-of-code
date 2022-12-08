include aoc

day 8:
    let trees = lines.mapIt(it.mapIt(parseInt($it)))
    part 1:
        var visible = initGrid[int](trees.width, trees.height)
        proc viewFrom(start: Point, dir: Point) =
            var cummax = -1
            var p = start
            while p in trees:
                if trees[p] > cummax:
                    visible[p] = 1
                    cummax = trees[p]
                p = p + dir
        for x in 0..<trees.width:
            viewFrom((x, 0), (0, 1))
            viewFrom((x, trees.height-1), (0, -1))
        for y in 0..<trees.height:
            viewFrom((0, y), (1, 0))
            viewFrom((trees.width-1, y), (-1, 0))
        sum visible.mapIt it.sum
    part 2:
        max:
            collect:
                for p, h in trees:
                    var score = 1
                    for d in directions4:
                        var i = 0
                        var nei = p + d
                        while nei.x in 0..<trees.width and nei.y in 0..<trees.height:
                            inc i
                            if trees[nei] >= h: break
                            nei = nei + d
                        score *= i
                    score
