include aoc
import memo

day 6:
    proc count(x: int, days: int): int {.memoized.} =
        if x > days or (x == 0 and days == 0):
            return 1
        elif x == 0:
            return count(6, days-1) + count(8, days-1)
        else:
            return count(0, days-x)
    part 1:
        ints.mapIt(count(it, 80)).sum
    part 2:
        ints.mapIt(count(it, 256)).sum