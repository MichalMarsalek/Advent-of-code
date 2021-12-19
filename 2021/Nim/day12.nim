include aoc

day 12:    
    var neighbours: Table[string,seq[string]]
    for line in lines:
        let (x,y) = line.scanTuple("$w-$w")
        neighbours.mgetOrPut(x, @[]).add y
        neighbours.mgetOrPut(y, @[]).add x
    
    proc getPaths(start: string, goal: string, freedom=0): int =
        proc genPaths(paths: var int, prefix: seq[string], freedom:int) =
            if prefix[^1] == goal:
                inc paths
            else:
                for cave in neighbours[prefix[^1]]:
                    if cave[0].isUpperAscii or cave notin prefix:
                        genPaths(paths, prefix & cave, freedom)
                    elif freedom > 0 and cave != start:
                        genPaths(paths, prefix & cave, freedom - 1)
        genPaths(result, @[start], freedom)
    part 1: getPaths("start", "end")
    part 2: getPaths("start", "end", 1)