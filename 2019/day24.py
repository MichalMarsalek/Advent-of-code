from aoc import *
from collections import *
from IntCode import *

def solve(inp):
    inp = inp.splitlines()
    grid = tuple(inp)
    seen = set([grid])
    for i in ints():
        grid = nxt(grid)
        if grid in seen:
            part1 = score(grid)
            break
        seen.add(grid)
    grid = defaultdict(int)
    for x in range(5):
        for y in range(5):
            if (x,y) != (2,2):
                grid[(x,y,0)] = 1 if inp[y][x] == "#" else 0
    for i in range(200):
        grid = nxt2(grid, i+1)
    #show(grid,10)
    part2 = sum(grid.values())
    return part1, part2

def nxt(grid):
    new = [list(line) for line in grid]
    for y in range(5):
        for x in range(5):
            bugs = 0
            for X, Y in neigbours4(x,y):
                if X in range(5) and Y in range(5):
                    bugs += grid[Y][X] == "#"
            if grid[y][x] == "#" and bugs != 1:
                new[y][x] = "."
            if grid[y][x] == "." and bugs in (1,2):
                new[y][x] = "#"
    return tuple("".join(line) for line in new)

def score(grid):
    res = 0
    for i in range(25):
        res += (grid[i // 5][i % 5] == "#") * 2 ** i
    return res

def neighbours(x, y, z):
    if (x,y) == (0,0):
        return [(1,2,z-1),(2,1,z-1),(1,0,z),(0,1,z)]
    if (x,y) == (0,4):
        return [(1,2,z-1),(2,3,z-1),(1,4,z),(0,3,z)]
    if (x,y) == (4,0):
        return [(2,1,z-1),(3,2,z-1),(4,1,z),(3,0,z)]
    if (x,y) == (4,4):
        return [(2,3,z-1),(3,2,z-1),(4,3,z),(3,4,z)]
    if (x,y) in [(1,0),(2,0),(3,0)]:
        return [(x-1,0,z),(x,1,z),(x+1,0,z),(2,1,z-1)]
    if (x,y) in [(0,1),(0,2),(0,3)]:
        return [(0,y-1,z),(1,y,z),(0,y+1,z),(1,2,z-1)]
    if (x,y) in [(1,4),(2,4),(3,4)]:
        return [(x-1,4,z),(x,3,z),(x+1,4,z),(2,3,z-1)]
    if (x,y) in [(4,1),(4,2),(4,3)]:
        return [(4,y-1,z),(3,y,z),(4,y+1,z),(3,2,z-1)]
    if (x,y) in [(1,1),(1,3),(3,1),(3,3)]:
        return [(X,Y,z) for X,Y in neigbours4(x,y)]
    if (x,y) == (2,1):
        return [(1,1,z),(2,0,z),(3,1,z),(0,0,z+1),(1,0,z+1),(2,0,z+1),(3,0,z+1),(4,0,z+1)]
    if (x,y) == (2,3):
        return [(1,3,z),(2,4,z),(3,3,z),(0,4,z+1),(1,4,z+1),(2,4,z+1),(3,4,z+1),(4,4,z+1)]
    if (x,y) == (1,2):
        return [(1,1,z),(0,2,z),(1,3,z),(0,0,z+1),(0,1,z+1),(0,2,z+1),(0,3,z+1),(0,4,z+1)]
    if (x,y) == (3,2):
        return [(3,1,z),(4,2,z),(3,3,z),(4,0,z+1),(4,1,z+1),(4,2,z+1),(4,3,z+1),(4,4,z+1)]

def show(grid, L):
    for z in range(-L, L+1):
        print(f"Depth {z}:")
        for y in range(5):
            line=""
            for x in range(5):
                if (x,y) == (2,2):
                    line += "?"
                else:
                    line += "#" if grid[(x,y,z)] else "."
            print(line)

def nxt2(grid, lvl):
    new = defaultdict(int)
    for z in range(-lvl,lvl+1):
        for x in range(5):
            for y in range(5):
                if (x,y) != (2,2):
                    bugs = sum(grid[n] for n in neighbours(x,y,z))
                    if grid[(x,y,z)] == 1:
                        new[(x,y,z)] = int(bugs == 1)
                    if grid[(x,y,z)] == 0:
                        new[(x,y,z)] = int(bugs in (1,2))
    return new

test = """....#
#..#.
#..##
..#..
#...."""
#print(solve(test))
run(solve)