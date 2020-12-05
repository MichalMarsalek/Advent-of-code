from aoc import *

def solve(inp):
    inp = inp.replace("-", " ").replace(":", "")
    inp = grid(inp)
    part1 = part2 = 0
    for l, h, c, pas in inp:
        part1 += l <= pas.count(c[0]) <= h
        part2 += ((pas[l-1] == c) ^ (pas[h-1] == c))
    return part1, part2

run(solve)