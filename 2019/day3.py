from aoc import *
from collections import *

def solve(inp):
    a,b = inp.splitlines()
    part1 = part2 = 10**10
    print(len(a.split(",")), len(b.split(",")))
    avis = first_visits(a)
    bvis = first_visits(b)
    for key in set(avis.keys()) & set(bvis.keys()):
        x,y = key
        part1 = min((part1, abs(x)+abs(y)))
        part2 = min((part2, avis[key]+bvis[key]))
    return part1, part2
    
def first_visits(moves):
    visits = dict()
    i = 1
    x,y = 0,0
    for move in moves.split(","):
        d = move[0]
        am = int(move[1:])
        dx, dy = 1,0
        if d in "LU":
            dx = -1
        if d in "UD":
            dx, dy = dy, dx
        for _ in range(am):
            x += dx
            y += dy
            if (x,y) not in visits:
                visits[(x,y)] = i
            i += 1
    return visits
            


run(solve)