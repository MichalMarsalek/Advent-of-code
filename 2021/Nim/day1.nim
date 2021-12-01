include aoc

day 1:
    part 1:
        zip(ints, ints[1..^1]).filterIt(it[1]>it[0]).len
    part 2:
        zip(ints, ints[3..^1]).filterIt(it[1]>it[0]).len
    part 3:
        "Some testing or upping the ante."