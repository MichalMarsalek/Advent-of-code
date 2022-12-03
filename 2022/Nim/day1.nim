include aoc

day 1:
    let elves = input.split("\n\n").map(x => x.ints.sum).sorted.reversed.cumsummed
    part 1: elves[0]
    part 2: elves[2]
