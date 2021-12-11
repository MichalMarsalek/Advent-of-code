include aoc

day 11:    
    proc update(grid: var Grid[int]):int =
        var q = grid.coordinates.toSeq
        for p in q: grid[p] += 1
        while q.len > 0:
            var p = q.pop
            if grid[p] >= 10:
                grid[p] = 0
                inc result
                for P in grid.neighbours(p,directions8):
                    if grid[P] > 0:
                        grid[P] += 1
                        q.add P
    
    var data = lines.map(l => l.mapIt(parseInt $it))
    part 1:
        sum mapIt(1..100, update(data))
    part 2:
        for i in 101..10000:
            if update(data) == data.size:
                return i