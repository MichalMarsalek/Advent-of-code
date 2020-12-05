from aoc import *

def solve(inp):
    grid = intgrid(inp)[2:]
    print(grid)
    part1 = 0
    for x,y,size, used, aval, _ in grid:
        for X,Y,SIZE,USED,AVAL, _ in grid:
            part1 += (x,y) != (X,Y) and used > 0 and used <= AVAL
    return part1
            

run(solve)