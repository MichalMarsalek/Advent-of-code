from aoc import *

def solve(inp):
    seats = inp.replace("F", "0").replace("B", "1").replace("L", "0").replace("R", "1")
    seats = seats.splitlines()
    seats = {int(x, 2) for x in seats}
    part1 = max(seats)
    for s in seats:
        if s+2 in seats and s+1 not in seats:
            part2 = s+1
    return part1, part2


run(solve)