include aoc

day 3:
    func priority(x: char): int =
        x.ord - (if x >= 'a': 'a'.ord - 1 else: 'A'.ord - 27)
    func common(parts: seq[string]): char =
        parts.mapIt(it.toHashSet).foldl(a*b).toSeq[0]
    part 1: sum lines.mapIt(priority common it.distribute 2)
    part 2: sum lines.groupsOf(3).mapIt(priority common it)
