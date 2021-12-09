include aoc

day 9:    
    var h = len lines
    var w = len lines[0]
    var basins: seq[HashSet[(int,int)]]
    var visited: HashSet[(int,int)]
    
    proc traverse(i,y,x:int) =
        basins[i].incl (y,x)
        visited.incl (y,x)
        for (dx,dy) in directions4:
            let X = x+dx
            let Y = y+dy
            if (X < 0) or (X >= w) or (Y < 0) or (Y >= h) or (Y,X) in visited or lines[Y][X] == '9':
                continue
            traverse(i,Y,X)
            
    var i = 0
    for y in 0..<h:
        for x in 0..<w:
            if (y,x) notin visited and lines[y][x] != '9':
                basins.add initHashSet[(int,int)]()
                traverse(i,y,x)
                i += 1        
    
    basins = basins.sortedByIt(it.card)

    part 1: basins.mapIt(it.map(x => parseInt($lines[x[0]][x[1]])+1).toSeq.min).sum
                    
    part 2: prod basins[^3..^1].map card
                    