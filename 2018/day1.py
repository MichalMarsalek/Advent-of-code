from aoc import *

def solve(inp):
    lines = intcolumn(inp)
    part1 = sum(lines)
    seen = set([0])
    f=0
    for x in 10000*lines:
        f += x
        if f in seen:
            return part1, f
        seen.add(f)
    part2 = None
    return part1, part2


run(solve)