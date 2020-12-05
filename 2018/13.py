from aoc import *
from collections import *

def solve(inp):
    grid0 = inp.splitlines()    
    grid = inp.replace(">","-").replace("<","-").replace("v", "|").replace("^","|").splitlines()    
    part1 = 0
    carts = []
    yy = len(grid)
    xx = max(len(line) for line in grid0)
    #for x in grid0:
    #    print(x)
    #grid0 = [x+".." for x in grid0]
    for y in range(yy):
        for x in range(xx):
            #print(x,y, len(grid0[y]))
            if grid0[y][x] in list("><v^"):
                dir = (-1, 0)
                if grid0[y][x] == ">":
                    dir = 1, 0
                elif grid0[y][x] == "^":
                    dir = 0, -1
                elif grid0[y][x] == "v":
                    dir = 0, 1
                carts.append((x,y,*dir))
    #print(carts)
    tick = 0
    turns = defaultdict(int)
    while len(carts)>1:
        perm = sorted(range(len(carts)), key=lambda i: carts[i][1]*1000+carts[i][0])
        #print(perm)
        carts = [carts[i] for i in perm]
        turns = [turns[i] for i in perm]
        tick += 1
        removed = []
        for i in range(len(carts)):
            if i not in removed:
                if moveCart(i, turns, carts, grid, removed):
                    #print(carts)
                    #print(tick, removed, carts[i][:2], [j for j in range(len(carts)) if tuple(carts[i][:2]) == tuple(carts[j][:2])])
                    removed.extend(j for j in range(len(carts)) if tuple(carts[i][:2]) == tuple(carts[j][:2]))
                    #print(tick, removed)
                    #return
                #print(carts)
        carts = [carts[i] for i in range(len(carts)) if i not in removed]
    part2 = carts[0][:2]
    return part1, part2

def moveCart(i, turns, carts, grid, removed):
    crash = False
    if (carts[i][0]+carts[i][2],carts[i][1]+carts[i][3]) in set(tuple(carts[i][:2]) for i in range(len(carts)) if i not in removed):
        crash = True
    x, y, dx, dy = carts[i]
    #print(carts[i])
    x += dx
    y += dy
    
    if crash:
        carts[i] = x, y, dx, dy
        return crash
    if grid[y][x] == "/":
        if dy == -1:
            dx, dy = 1, 0
        elif dx==-1:
            dx, dy = 0, 1
        elif dy == 1:
            dx, dy = -1, 0
        else:
            dx, dy = 0, -1
    elif grid[y][x] == "\\":
        if dy == -1:
            dx, dy = -1, 0
        elif dx==-1:
            dx, dy = 0, -1
        elif dy == 1:
            dx, dy = 1, 0
        else:
            dx, dy = 0, 1
    elif grid[y][x] == "+":
        if turns[i] % 3 == 0:
            dx, dy = dy, -dx
        elif turns[i] % 3 == 2:
            dx, dy = -dy, dx
        turns[i] += 1
    carts[i] = x, y, dx, dy
    return crash


run(solve, 13, True)