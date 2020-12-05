from aoc import *

def solve(inp):
    grid = intgrid(inp)
    part1 = sum((a+b) > c for a,b,c in map(sorted, grid))
    part2 = 0
    for y in range(len(grid)//3):
        for x in range(3):
            a, b, c = sorted([grid[y*3][x], grid[y*3+1][x], grid[y*3+2][x]])
            part2 += (a+b) > c
    return part1, part2

run(solve)