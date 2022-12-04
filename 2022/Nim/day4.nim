include aoc

day 4:
    let ranges = lines.mapIt(it.replace("-", "..").ints4)
    part 1:
        sum(
            for (a, b, c, d) in ranges:
                int((c >= a and d <= b) or (a >= c and b <= d))
        )
    part 2: sum(for (a, b, c, d) in ranges: int((c <= b) and (a <= d)))
