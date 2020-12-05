from aoc import *
from collections import *

def solve(inp):
    inp = intgrid(inp)
    grid = [10001*[0] for _ in range(10001)]
    for x, a, b, c, d in inp:
        for cc in range(c):
            for dd in range(d):
                grid[a+cc][b+dd] += 1
    part1 = 0
    for x in range(1001):
        for y in range(1001):
            if grid[x][y] >= 2:
                part1 += 1
    for x,a,b,c,d in inp:
        overlap = False
        for cc in range(c):
            for dd in range(d):
                overlap = overlap or grid[a+cc][b+dd] >= 2
        if not overlap:
            part2 = x
    return part1, part2


run(solve)