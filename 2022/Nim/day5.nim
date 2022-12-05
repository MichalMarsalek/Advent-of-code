include aoc

day 5:
    let g = inputRaw.split "\n\n"
    let width = max ints g[0]
    var stacks = initGrid[char](0, width)
    for line in splitLines(g[0])[0..^2]:
        for i, x in line.distribute(width):
            let y = x[1]
            if y != ' ':
                stacks[i] = y & stacks[i]
    let ins = g[1].splitLines.map ints3
    func rearranged(stacks: Grid[char], ins: seq[Point3], oneByOne: bool): Grid[char] =
        result = deepCopy stacks
        for (a, b, c) in ins:
            var items = result[b-1][^a..^1]
            result[b-1] = result[b-1][0..^(a+1)]
            if oneByOne: reverse items
            result[c-1] &= items
    func solve(part: range[1..2]): string =
        stacks.rearranged(ins, part == 1).mapIt(it[^1]).join
    part 1: solve 1
    part 2: solve 2
