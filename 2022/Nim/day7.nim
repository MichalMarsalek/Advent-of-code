include aoc

day 7:
    var path: seq[string]
    var dirs: Table[seq[string], int]
    for line in lines:
        var name: string
        var size: int
        if line == "$ cd ..":
            let s = dirs[path]
            discard path.pop
            dirs[path] = dirs.getOrDefault(path) + s
        elif line.scanf("$$ cd $*", name):
            path &= name
        elif line.scanf("$i $*", size, name):
            dirs[path] = dirs.getOrDefault(path) + size
    while path.len > 1:
        let s = dirs[path]
        discard path.pop
        dirs[path] += s
    let sizes = dirs.values.toSeq
    part 1: sizes.filterIt(it <= 100000).sum
    part 2: sizes.filterIt(70000000 - dirs[@["/"]] + it >= 30000000).min
