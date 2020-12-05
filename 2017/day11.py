from aoc import *
from math import *

def solve(inp):
    dirs = {"n": (0, -1), "ne": (1, -0.5), "se": (1, 0.5), "s": (0, 1), "sw":(-1, 0.5), "nw":(-1, -0.5)}
    x, y = 0, 0
    part2 = 0
    for d in inp.split(","):
        dx, dy = dirs[d]
        x, y = x+dx, y+dy
        part2 = max(part2, dist(x, y))
    part1 = dist(x, y)
    return part1, part2

def dist(x, y):
    x, y = abs(x), abs(y)
    return ceil(x+max(0, y-x/2))

run(solve)