include aoc

day 20:
    #echo input
    var grid: HashSet[Point]
    var rules: seq[bool]
    rules = lines[0].mapIt(it == '#')
    
    for y,L in lines[2..^1]:
        for x,c in L:
            if c == '#':
                grid.incl (x,y-2)
    var odd = false
    
    proc nxt(grid:HashSet[Point]):HashSet[Point] =
        let pSeq = grid.toSeq
        for x in -200..300:
            for y in -200..300:
                var i = 0
                for X,Y in neighbours((x,y), directions9):
                    i = i*2 + int((X,Y) in grid)
                if rules[i]:
                    result.incl (x,y)
            
    part 1,int:
        var grid2 = grid.nxt.nxt
        for x in -25..125:
            for y in -25..125:
                result += int((x,y) in grid2)
    part 2,int:
        var grid2 = grid
        for _ in 1..50:
            grid2 = grid2.nxt
        for x in -60..160:
            for y in -60..160:
                result += int((x,y) in grid2)