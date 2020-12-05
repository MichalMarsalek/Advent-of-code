from aoc import *

def solve(inp):
    nums = set(intcolumn(inp)) #helper function to load a column integer vector from string
    for a in nums:
        for b in nums - {a}:
            if a + b == 2020:
                part1 = a * b
            c = 2020 - a - b
            if c in nums:
                part2 = a * b * c
    return part1, part2


run(solve)