from aoc import *
from collections import *

def solve(inp):
    inp = intcolumn(inp)    
    part1 = sum(x//3-2 for x in inp)    
    part2 = sum(fuel(x) for x in inp)
    return part1, part2

def fuel(m):
    if m//3 - 2 < 0:
        return 0
    return m//3-2 + fuel(m//3-2)


run(solve)