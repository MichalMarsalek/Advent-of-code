from aoc import *
from collections import *
from asm import *

def nxt(grid):
    cpy = [list(x) for x in grid]
    changed = False
    for y in range(len(grid)):
        for x in range(len(grid[0])):
            n = 0
            for X, Y in neigbours8(x,y):
                if Y in range(len(grid)) and X in range(len(grid[0])):
                    n += grid[Y][X] == "#"
            
            if grid[y][x] == "L" and n == 0:
                cpy[y][x] = "#"
                changed = True
                
            elif grid[y][x] == "#" and n >= 4:
                cpy[y][x] = "L"
                changed = True
    return cpy,changed

def nxt2(grid):
    cpy = [list(x) for x in grid]
    changed = False
    for y in range(len(grid)):
        for x in range(len(grid[0])):
            n = 0
            for dX, dY in directions8:
                for k in ints():
                    X = x + k*dX
                    Y = y + k*dY
                    if Y in range(len(grid)) and X in range(len(grid[0])):
                        n += grid[Y][X] == "#"
                        if grid[Y][X] in "L#":
                            break
                    else:
                        break
            
            if grid[y][x] == "L" and n == 0:
                cpy[y][x] = "#"
                changed = True
                
            elif grid[y][x] == "#" and n >=5:
                cpy[y][x] = "L"
                changed = True
    return cpy,changed

def solve(inp):
    grid = inp.splitlines()
    while True:
        grid, changed = nxt(grid)
        if not changed:
            break
    part1 = sum(sum(x == "#" for x in line) for line in grid)
    
    grid = inp.splitlines()
    while True:
        grid, changed = nxt2(grid)
        if not changed:
            break
    part2 = sum(sum(x == "#" for x in line) for line in grid)
    return part1, part2


run(solve)