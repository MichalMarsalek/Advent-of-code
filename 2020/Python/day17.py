from aoc import *
from collections import *
from asm import *

def nxt(grid, mode_4D = False):
    new = set()
    count_neigh = defaultdict(int)
    for x,y,z,w in grid:
        for dx in (-1,0,1):
            for dy in (-1,0,1):
                for dz in (-1, 0, 1):
                    if mode_4D:
                        for dw in (-1, 0, 1):
                            if (dx,dy,dz,dw) != (0,0,0,0):
                                count_neigh[(x+dx,y+dy,z+dz,w+dw)] += 1
                    else:
                        if (dx,dy,dz) != (0,0,0):
                            count_neigh[(x+dx,y+dy,z+dz,w+0)] += 1
    for x,y,z,w in count_neigh:
        if (x,y,z,w) in grid:
            if count_neigh[(x,y,z,w)] in (2,3):
                new.add((x,y,z,w))
        else:
            if count_neigh[(x,y,z,w)] == 3:
                new.add((x,y,z,w))
    return new
    
def solve(inp):
    data = inp.splitlines()    
    grid1 = set()
    for i, row in enumerate(data):
        for j, col in enumerate(row):
            if col == "#":
                grid1.add((j,i,0,0))
    grid2 = set(grid1)
    for _ in range(6):
        grid1 = nxt(grid1)
    part1 = len(grid1)
    for _ in range(6):
        grid2 = nxt(grid2, True)
    part2 = len(grid2)
    return part1, part2


run(solve)