import aoc
import strutils

solution:
    let data = inp.replace("F", "0").replace("B", "1").replace("L", "0").replace("R", "1")
    var seats = newSet[int16]()
    for s in seats.split("\n"):
        seats += {x.parseInt(2)}
    part1:
        max(seats)
    part2:
        for s in seats:
            if s+2 in seats and s+1 notin seats:
                return s+1
                