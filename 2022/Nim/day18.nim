include aoc

day 18:
    let dirs = [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)]
    func countNonoverlappingEdges(cubes: HashSet[Point3]): int =
        for a in cubes:
            result += 6
            for dir in dirs:
                if (a+dir) in cubes:
                    result -= 1
    let cubes = lines.map ints3
    let cubes1 = cubes.toHashSet
    part 1: countNonoverlappingEdges cubes1
    part 2:
        let xRange = (cubes.map(x).min - 1)..(cubes.map(x).max + 1)
        let yRange = (cubes.map(y).min - 1)..(cubes.map(y).max + 1)
        let zRange = (cubes.map(z).min - 1)..(cubes.map(z).max + 1)
        var cubes2: HashSet[Point3]
        for x in xRange:
            for y in yRange:
                for z in zRange:
                    cubes2.incl (x, y, z)
        var q = @[(xRange.a, yRange.a, zRange.a)]
        while q.len > 0:
            let a = pop q
            cubes2.excl a
            for dir in dirs:
                let b = a+dir
                if b in cubes2 and b notin cubes1:
                    q.add b
        countNonoverlappingEdges cubes2

