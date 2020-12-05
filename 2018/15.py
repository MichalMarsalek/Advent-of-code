from aoc import *
from collections import *

def solve(inp):
    inp = inp.splitlines()
    part1 = 0
    mapa = [list(x) for x in inp]
    h = len(mapa)
    w = len(mapa[0])
    hp = [w*[0] for _ in range(h)]
    for y in range(h):
        for x in range(w):
            if mapa[y][x] in ("E","G"):
                hp[y][x] = 200
    round = 0
    printmapa(mapa, hp)
    while any("G" in row for row in mapa) and any("E" in row for row in mapa):
        units = [(x,y) for y in range(h) for x in range(w) if hp[y][x] != 0]
        #print(hp)
        #print(units)
        for ux, uy in units:
            target = findtarget(mapa, hp, ux, uy)
            if target is None:
                path = findpath(mapa, ux, uy)
                #print(ux, uy, path)
                if path is not None:
                    nx, ny = path
                    hp[ny][nx] = hp[uy][ux]
                    hp[uy][ux] = 0
                    mapa[ny][nx] = mapa[uy][ux]
                    mapa[uy][ux] = "."
                    ux, uy = nx, ny
            target = findtarget(mapa, hp, ux, uy)
            if target is not None:
                tx, ty = target
                hp[ty][tx] -= 3
                if hp[ty][tx] <= 0:
                    hp[ty][tx] = 0
                    mapa[ty][tx] = "."
        round += 1
        #print(round, sum(sum(r) for r in hp))
        #printmapa(mapa, hp)
        #print()
    round -= 1
    part1 = round * sum(sum(r) for r in hp)
    part2 = 0
    return part1, part2

def printmapa(mapa, hp):
    for i,l in enumerate(mapa):
        print("".join(l) + "   " + ", ".join(str(hpp) for hpp in hp[i] if hpp))

def findpath(mapa, x, y):
    type = mapa[y][x]
    target = "E" if type == "G" else "G"
    reach = [(x,y, None, None)]
    reachset = set([(x,y)])
    directions4 = (0, -1), (-1, 0), (1, 0), (0, 1)
    #print("searching paths from " + str(x) + ", " + str(y))
    while reach:
        reach2 = []
        for x,y, startx0, starty0 in reach:
            for dx, dy in directions4:
                nx, ny = x + dx, y + dy
                if startx0 is None:
                    startx, starty = nx, ny
                else:
                    startx, starty = startx0, starty0
                if (nx, ny) not in reachset and mapa[ny][nx] in (target, "."):
                    #print(x, y, nx, ny, startx, starty, mapa[ny][nx])
                    reach2.append((nx, ny, startx, starty))
                    reachset.add((nx, ny))
                    if mapa[ny][nx] == target:
                        return startx, starty
        reach = reach2

def findtarget(mapa, hp, x, y):
    #print(x,y)
    type = mapa[y][x]
    targ = "E" if type == "G" else "G"
    directions4 = (0, -1), (-1, 0), (1, 0), (0, 1)
    targets = []
    for dx, dy in directions4:
        nx, ny = x + dx, y + dy
        if mapa[ny][nx] == targ:
            targets.append((nx, ny))
    targets.sort(key=(lambda xy: hp[xy[1]][xy[0]]))
    if targets:
        return targets[0]


run(solve)