include aoc

day 7:
    var path: seq[string]
    var dirs: Table[string, int]
    for line in lines[1..^1]:
        let p = line.split
        if p[0] == "$" and p[1] == "cd":
            if p[2] == "..":
                let s = dirs[path.join "/"]
                discard path.pop
                dirs[path.join "/"] += s
            else:
                path &= p[2]
        else:
            let j = path.join "/"
            if j notin dirs:
                dirs[j] = 0
            dirs[j] += sum ints p[0]
    while path.len > 0:
        let s = dirs[path.join "/"]
        discard path.pop
        dirs[path.join "/"] += s

    part 1, int:
        sum:
            collect:
                for d, s in dirs:
                    if s <= 100000:
                        s
    part 2:
        min:
            collect:
                for d, s in dirs:
                    if 70000000 - dirs[""] + s >= 30000000:
                        s

