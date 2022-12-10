include aoc

day 10:
    var xHistory = @[1]
    for line in lines:
        xHistory &= xHistory[^1]
        if line != "noop":
            xHistory &= xHistory[^1] + ints1 line
    part 1:
        sum(for c in countup(20, 220, 40): c * xHistory[c-1])
    part 2:
        var crt = collect:
            for y in 0..5:
                for x in 0..39:
                    if abs(xHistory[x+40*y] - x) <= 1:
                        (x, y)
        plot crt
