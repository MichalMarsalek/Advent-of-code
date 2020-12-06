from aoc import *

def solve(inp):
    inp = inp.split("\n\n")
    part1 = part2 = 0
    for group in inp:
        ans = [set(x) for x in group.split()]
        part1 += len(set.union(*ans))
        part2 += len(set.intersection(*ans))
    return part1, part2


run(solve)