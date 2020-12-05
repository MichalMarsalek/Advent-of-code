from aoc import *
from collections import *
from IntCode import *

def solve(inp):
    alpha = "QWERTZUIOPASDFGHJKLYXCVBNM"    
    maze = inp.splitlines()
    tp0 = defaultdict(list)     #temp for finding pairs of connecting coordinates
    tp = dict()                 #map TP in to TP out
    h = len(maze)
    w = len(maze[0])
    part1 = 10**10
    part2 = None
    
    #find TPs
    for y in range(h):
        for x in range(w):
            if maze[y][x] == "." and maze[y][x-1] in alpha and maze[y][x-2] in alpha:
                tp0[maze[y][x-2:x]].append((x,y))
            if maze[y][x] == "." and maze[y][x+1] in alpha and maze[y][x+2] in alpha:
                tp0[maze[y][x+1:x+3]].append((x,y))
            if maze[y][x] == "." and maze[y-1][x] in alpha and maze[y-2][x] in alpha:
                tp0[maze[y-2][x] + maze[y-1][x]].append((x,y))
            if maze[y][x] == "." and maze[y+1][x] in alpha and maze[y+2][x] in alpha:
                tp0[maze[y+1][x] + maze[y+2][x]].append((x,y))
    for P in tp0.values():
        if len(P) == 2:
            p1, p2 = P
            tp[p1] = p2
            tp[p2] = p1
    
    #BFS
    x,y = tp0["AA"][0]
    queue = deque([(x,y,0,0)])
    seen = {(x,y,0)}
    while not part2:
        x, y, z, i = queue.popleft()
        if tp0["ZZ"][0] == (x,y):     #check goal
            part1 = min(part1, i)
            if z == 0:
                part2 = i
        for X, Y in neigbours4(x, y): #regular movement
            if maze[Y][X] == ".":
                if (X,Y,z) not in seen:
                    queue.append((X,Y,z,i+1))
                    seen.add((X,Y,z))
        if (x,y) in tp:               #teleportation
            X,Y = tp[(x,y)]
            Z = z-1 if x in (2, w-3) or y in (2, h-3) else z+1            
            if Z >= 0 and (X,Y,Z) not in seen:
                queue.append((X,Y,Z,i+1))
                seen.add((X,Y,Z))
    return part1, part2

run(solve, dontStrip=True)