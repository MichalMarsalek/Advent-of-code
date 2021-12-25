include aoc

day 25:
    proc nxt(grid:Grid[char], target:char, dir: Point):Grid[char] =
        result = initGrid(grid.width, grid.height, '.')
        for p, c in grid:
            let p2 = ((p.x + dir.x) mod grid.width,(p.y + dir.y) mod grid.height)
            if c == target and grid[p2] == '.':
                result[p2] = target
            elif c != '.':
                result[p] = c
       
    part 1,int:
        var grid = lines.map(L => L.mapIt it)
        while true:
            inc result
            let temp = grid.nxt('>',(1,0)).nxt('v',(0,1))
            if temp == grid: return
            grid = temp