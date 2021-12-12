include aoc

day 12:    
    var neighbours: Table[string,seq[string]]
    for line in lines:
        let (_,x,y) = line.scanTuple("$w-$w")
        if x notin neighbours: neighbours[x] = newSeq[string]()
        if y notin neighbours: neighbours[y] = newSeq[string]()
        neighbours[x].add y
        neighbours[y].add x
    
    proc getPaths(start: string, goal: string, freedom=0): seq[seq[string]] =
        proc genPaths(paths: var seq[seq[string]], prefix: seq[string], freedom:int) =
            if prefix[^1] == goal:
                paths.add prefix
            else:
                for cave in neighbours[prefix[^1]]:
                    if cave[0].isUpperAscii or cave notin prefix:
                        genPaths(paths, prefix & cave, freedom)
                    elif freedom > 0 and cave != start:
                        genPaths(paths, prefix & cave, freedom - 1)
        genPaths(result, @[start], freedom)
    part 1: getPaths("start", "end").len
    part 2: getPaths("start", "end", 1).len