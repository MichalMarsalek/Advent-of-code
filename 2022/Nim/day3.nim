include aoc

day 3:
    func priority(x: char): int =
        x.ord - (if x >= 'a': 'a'.ord - 1 else: 'A'.ord - 27)
    func common(parts: varargs[string]): char =
        parts.mapIt(it.toHashSet).foldl(a*b).toSeq[0]
    part 1, int:
        for line in lines:
            let n = line.len div 2
            result += priority common(line[0..<n], line[n..^1])
    part 2, int:
        for i in 0..<(lines.len div 3):
            result += priority common(lines[3*i], lines[3*i+1], lines[3*i+2])
