from aoc import *
from collections import *

def edge(grid, side):
    if side == "up":
        return grid[0]
    if side == "down":
        return grid[-1]
    if side == "left":
        return transpose(grid)[0]
    if side == "right":
        return transpose(grid)[-1]
    
def flip_ud(grid):
    return grid[::-1]
def transpose(grid):
    return list(map(lambda x: "".join(x), zip(*grid)))
def rotate_l(grid):
    return flip_ud(transpose(grid))

def transform(grid, s):
    if s >= 4:
        return transform(transpose(grid), s-4)
    for _ in range(s):
        grid = rotate_l(grid)
    return grid    

pattern = """                  # 
#    ##    ##    ###
 #  #  #  #  #  #   """.splitlines()
checks = [(x,y) for y in range(len(pattern)) for x in range(len(pattern[0])) if pattern[y][x] == "#"]
def is_monster(sea, x,y):
    return all(sea[y+dy][x+dx] == "#" for dx,dy in checks)
    
def count_monsters(sea):
    res = 0
    for x in range(len(sea)-20):
        for y in range(len(sea)-3):
            res += is_monster(sea, x, y)
    return res
    

def solve(inp):
    data = inp.split("\n\n")
    grids = [x.splitlines()[1:] for x in data]
    ids = [int(x.splitlines()[0][5:-1]) for x in data]
    mapping = {id: grid for id, grid in zip(ids, grids)}
    megagrid = [12*[None] for _ in range(12)]
    megagrid_ids = [12*[None] for _ in range(12)]
    part1 = None
    part2 = None
    def arrange(ids, x, y):
        nonlocal part1, part2
        if part1 is not None:
            return
        #print(len(ids), x, y)
        if not ids:
            part1 = megagrid_ids[0][0] * megagrid_ids[0][-1] * megagrid_ids[-1][0] * megagrid_ids[-1][-1]
            part2 = [list(x) for x in megagrid]
            return
        for i,id in enumerate(ids):
            g = mapping[id]
            for s in range(8):
                g2 = transform(g,s)
                seam1 = x == 0 or edge(g2, "left") == edge(megagrid[y][x-1], "right")
                seam2 = y == 0 or edge(g2, "up") == edge(megagrid[y-1][x], "down")
                if seam1 and seam2:
                    megagrid[y][x] = g2
                    megagrid_ids[y][x] = id
                    arrange(ids[:i]+ids[i+1:], (x+1)%12, y + (x+1)//12)
    arrange(ids, 0,0)
    final_map = []
    size = len(megagrid)*len(megagrid[0][0])
    for megarow in part2:
        for row in range(1, len(part2[0][0])-1):
            final_map.append("".join(grid[row][1:-1] for grid in megarow))
    for s in range(8):
        count = count_monsters(transform(final_map, s))
        if count:
            part2 = sum(x.count("#") for x in final_map)-count * 15
    return part1, part2


run(solve)