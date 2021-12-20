include aoc

day 20:
    type InfGrid = object
        bounds:Slice[int]
        parity:range[0..1]
        data: HashSet[Point]
    func card(grid: InfGrid): int = grid.data.card
        
    var rules: seq[bool]
    rules = lines[0].mapIt(it == '#')
    var grid = InfGrid(bounds: 0..99)
    for y,L in lines[2..^1]:
        for x,c in L:
            if c == '#':
                grid.data.incl (x,y)
    
    proc nxt(grid: InfGrid): InfGrid =
        result = InfGrid(bounds: grid.bounds.a-1..grid.bounds.b+1, parity: 1-grid.parity)
        for x in result.bounds:
            for y in result.bounds:
                var i = 0
                for X,Y in neighbours((x,y), directions9):
                    if X in grid.bounds and Y in grid.bounds:
                        i = i*2 + int((X,Y) in grid.data)
                    else:
                        i = i*2 + grid.parity
                if rules[i]:
                    result.data.incl (x,y)
            
    part 1: card (nxt^2) grid
    part 2: card (nxt^50) grid