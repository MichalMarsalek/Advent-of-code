include aoc
import heapqueue

func shortestDistance(grid: Grid[int], a, b: Point):int =
    var dist = {a: 0}.toTable
    var seen = [a].toHashSet
    var q = {0:a}.toHeapQueue
    while true:
        let v = q.pop[1]
        if v == b: return dist[b]
        seen.incl v
        for u in grid.neighbours(v):
            if u notin seen:
                let newCost = dist[v] + grid[u]
                if newCost < dist.getOrDefault(u, 2^60):                
                    dist[u] = newCost
                    #set penalty to 0 for Dijkstra
                    let penalty = norm1(b-u)
                    q.push (dist[u] + penalty, u)

day 15:   
    let grid = lines.map(L => L.mapIt(parseInt $it))
    
    part 1:
        grid.shortestDistance((0,0), (grid.width-1, grid.height-1))
    part 2:
        var grid2: Grid[int]
        for y in 0..4:
            for r in grid:
                let r = r
                grid2.add concat toSeq(0..4).map(x => r.mapIt((it + x + y + 8) mod 9 + 1))
        grid2.shortestDistance((0,0), (grid2.width-1, grid2.height-1))