include aoc

day 3:
    func priority(x: char): int =
        x.ord - (if x >= 'a': 'a'.ord - 1 else: 'A'.ord - 27)
    func common(parts: seq[string]): char =
        parts.mapIt(it.toHashSet).foldl(a*b).toSeq[0]
    let priorityOfCommon = priority * common
    part 1: sum lines.mapIt(it.distribute 2).map priorityOfCommon
    part 2: sum lines.groupsOf(3).map priorityOfCommon
