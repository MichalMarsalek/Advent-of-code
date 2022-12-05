include aoc

day 5:
    let g = input.split "\n\n"
    let width = max ints g[0]
    var stacks = initGrid[char](0, width)
    for line in reversed g[0].splitLines[0..^2]:
        for i, x in line.distribute(width):
            let y = x[1]
            if y != ' ':
                stacks[i] &= y
    let ins = g[1].splitLines.map ints3
    func rearranged(stacks: Grid[char], ins: seq[Point3], preserveOrder: bool): Grid[char] =
        result = deepCopy stacks
        for (a, b, c) in ins:
            var items = result[b-1].popSeq(a, preserveOrder)
            result[c-1] &= items
    func solve(part: range[1..2]): string =
        stacks.rearranged(ins, part == 2).mapIt(it[^1]).join
    part 1: solve 1
    part 2: solve 2
