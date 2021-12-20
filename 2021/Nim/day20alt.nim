include aoc

day 20:
    type InfGrid = object
        bounds:Slice[int]
        parity:range[0..1]
        data: Grid[int]
    func card(grid: InfGrid): int =
        grid.data[grid.bounds].mapIt(sum it[grid.bounds]).sum
        
    var rules: seq[int]
    rules = lines[0].mapIt(int(it == '#'))
    var grid = InfGrid(bounds: 50..149, data: initGrid[int](200,200))
    for y,L in lines[2..^1]:
        for x,c in L:
            if c == '#':
                grid.data[x+50,y+50] = 1
    
    proc nxt(grid: InfGrid): InfGrid =
        result = InfGrid(bounds: grid.bounds.a-1..grid.bounds.b+1,
                         parity: 1-grid.parity,
                         data: initGrid[int](200,200))
        for x in result.bounds:
            for y in result.bounds:
                var i = 0
                for X,Y in neighbours((x,y), directions9):
                    if X in grid.bounds and Y in grid.bounds:
                        i = i*2 + int(grid.data[X,Y])
                    else:
                        i = i*2 + grid.parity
                result.data[x,y] = rules[i]
            
    part 1: card (nxt^2) grid
    part 2: card (nxt^50) grid