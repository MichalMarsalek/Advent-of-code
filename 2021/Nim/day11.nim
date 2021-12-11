include aoc

day 11:    
    proc update(grid: var Grid[int]):int =
        var q = grid.coordinates.toSeq
        var flashed: HashSet[Point]
        while q.len > 0:
            var p = q.pop
            grid[p] += 1
            if grid[p] >= 10 and p notin flashed:
                flashed.incl p
                for P in grid.neighbours(p,directions8):
                    q.add P
        for p in grid.coordinates:
            if grid[p] >= 10:
                grid[p] = 0
        return flashed.len        
    
    var data = lines.map(l => l.mapIt(parseInt $it))
    part 1,int:
        for i in 1..100:
            result += update(data)
    part 2:
        for i in 101..10000:
            if update(data) == data.size:
                return i