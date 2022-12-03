include aoc

day 3:
    func priority(x: char): int =
        x.ord - (if x >= 'a': 'a'.ord - 1 else: 'A'.ord - 27)
    func priorityMaxCommon(parts: varargs[string]): int =
        max parts.mapIt(it.toHashSet).foldl(a*b).toSeq.map(priority)
    part 1, int:
        for line in lines:
            let n = line.len div 2
            result += priorityMaxCommon(line[0..<n], line[n..^1])
    part 2, int:
        for i in 0..<(lines.len div 3):
            result += priorityMaxCommon(lines[3*i], lines[3*i+1], lines[3*i+2])
