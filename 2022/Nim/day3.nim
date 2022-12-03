include aoc

day 3:
    func priority(x: char): int =
        x.ord - (if x >= 'a': 'a'.ord - 1 else: 'A'.ord - 27)
    func common(parts: seq[string]): char =
        parts.mapIt(it.toSet).foldl(a*b).toSeq[0]
    part 1: sum lines.mapIt(it.distribute 2).map priority * common
    part 2: sum lines.groupsOf(3).map priority * common
