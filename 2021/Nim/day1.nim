include aoc

day(1):
    part1:
        zip(ints, ints[1..^1]).filterIt(it[1]>it[0]).len
    part2:
        zip(ints, ints[3..^1]).filterIt(it[1]>it[0]).len