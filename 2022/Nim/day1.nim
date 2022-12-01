include aoc

day 1:
    let calories = input.split("\n\n").map(x => x.ints.sum)
    part 1: calories.max
    part 2: calories.sorted[^3..^1].sum
