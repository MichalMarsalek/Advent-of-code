from aoc import *
from collections import Counter

def solve(inp):
    p = intgrid(inp)
    pos = [[p[i][0], p[i][1]] for i in range(len(p))]
    vel = [(p[i][2], p[i][3]) for i in range(len(p))]
    for i in range(1,30000):
        sim(pos, vel)
        if max(x[0] for x in pos)-min(x[0] for x in pos) < 100 and max(x[1] for x in pos)-min(x[1] for x in pos) < 50:
            print(i)
            printmess(pos,i)
            print()
    part1 = "CRXKEZPZ"
    part2 = 10081
    return part1, part2

def sim(pos, vel):
    for i in range(len(pos)):
        pos[i][0] += vel[i][0]
        pos[i][1] += vel[i][1]

def printmess(pos, i):
    pos = list(map(tuple, pos))
    for y in range(min(f[1] for f in pos), max(f[1] for f in pos)+1):
        l = ""
        for x in range(min(f[0] for f in pos), max(f[0] for f in pos)+1):
            l += "#" if (x,y) in pos else "."
        print(l)

run(solve)