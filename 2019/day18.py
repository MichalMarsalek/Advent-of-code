from aoc import *
from collections import *
from IntCode import *
import sys
sys.setrecursionlimit(4000)

fset = frozenset

def solve(inp):
    print(inp)
    maze = inp.splitlines()
    part1 = part2 = None
    h, w = len(maze), len(maze[0])
    maze = [list(x) for x in maze]
    maze[h//2][w//2-1] = maze[h//2][w//2+1] = "#"
    maze[h//2-1][w//2] = maze[h//2+1][w//2] = "#"
    x, y = w//2, h//2
    plug(maze, x, y)
    maze[h//2][w//2-1] = maze[h//2][w//2+1] = "."
    maze[h//2-1][w//2] = maze[h//2+1][w//2] = "."
    queue = deque([(x,y,fset({"."}),0)])
    seen = {(x,y,fset({"."}))}    
    keys  = "qwertzuiopasdfghjklyxcvbnm"
    doors = "QWERTZUIOPASDFGHJKLYXCVBNM"
    no_keys = sum(maze[y][x] in keys for x in range(w) for y in range(h))
    while not part1:
        x, y, unlocked, i = queue.popleft()
        if len(unlocked)-1 == no_keys:
            part1 = i
        for X, Y in neigbours4(x, y): #regular movement
            if maze[Y][X] in unlocked:
                if (X,Y,unlocked) not in seen:
                    queue.append((X,Y,unlocked,i+1))
                    seen.add((X,Y,unlocked))
            if maze[Y][X] in keys:
                UNLOCKED = fset(list(unlocked) + [maze[Y][X].upper()])
                if (X,Y,UNLOCKED) not in seen:
                    queue.append((X,Y,UNLOCKED,i+1))
                    seen.add((X,Y,UNLOCKED))
    #return part1
    h,w = len(maze), len(maze[0])
    maze = [list(x) for x in maze]
    maze[h//2][w//2-1] = maze[h//2][w//2+1] = "#"
    maze[h//2-1][w//2] = maze[h//2+1][w//2] = "#"
    x, y = w//2, h//2
    print("\n".join("".join(x) for x in maze))
    #return
    queue = deque([(((x-1, y-1), (x-1, y+1), (x+1, y-1), (x+1, y+1)) ,fset({"."}),0)])
    seen = {(((x-1, y-1), (x-1, y+1), (x+1, y-1), (x+1, y+1)) ,fset({"."}))}
    no_keys = sum(maze[y][x] in keys for x in range(w) for y in range(h))
    while not part2:
        robots, unlocked, i = queue.popleft()
        if len(unlocked)-1 == no_keys:
            part2 = i
        for r in range(4):
            x, y = robots[r]
            for X, Y in neigbours4(x, y): #regular movement
                if maze[Y][X] == ".":
                    #print("Start", x,y,X,Y)
                    x, y, X, Y = continue_movement(maze, x, y, X, Y)
                    #print("END", x,y,X,Y)
                ROBOTS0 = change_r(robots, r, x, y)
                ROBOTS1 = change_r(robots, r, X, Y)
                if maze[Y][X] in unlocked:
                    if (ROBOTS1,unlocked) not in seen:
                        queue.append((ROBOTS1,unlocked,i+1))
                        seen.add((ROBOTS0,unlocked))
                        seen.add((ROBOTS1,unlocked))
                if maze[Y][X] in keys:
                    UNLOCKED = fset(list(unlocked) + [maze[Y][X].upper()])
                    if (ROBOTS1,UNLOCKED) not in seen:
                        queue.append((ROBOTS1,UNLOCKED,i+1))
                        seen.add((ROBOTS0,unlocked))
                        seen.add((ROBOTS1,unlocked))
    return part1, part2

def continue_movement(maze, x, y, X, Y):
    while True:
        ways = [(X2,Y2) for X2,Y2 in neigbours4(X, Y) if (X2,Y2) != (x,y) and maze[Y2][X2] == "."]
        if len(ways) == 1:
            x, y = X, Y
            X, Y = ways[0]
        else:
            return x, y, X, Y
            
        

def change_r(robots, r, x, y):
    res = [tuple(robots[i]) for i in range(4)]
    res[r] = (x,y)
    return tuple(res)

def plug(maze, cx, cy):
    def vis(x, y, lx=None, ly=None):
        neigh = [(X,Y) for X,Y in neigbours4(x, y) if maze[Y][X] != "#" and (X,Y) != (lx,ly)]
        if any([vis(X,Y, x, y) for X,Y in neigh]) or maze[y][x] != ".":
            return True
        else:
            maze[y][x] = "#"
            return False
    vis(cx-1, cy-1)
    vis(cx-1, cy+1)
    vis(cx+1, cy-1)
    vis(cx+1, cy+1)
    

test="""#######
#a.#Cd#
##@#@##
#######
##@#@##
#cB#Ab#
#######"""
#print(solve(test))
run(solve)