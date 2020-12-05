from aoc import *
from collections import *

size = 50
def solve(inp):
    state = inp.splitlines()
    for i in range(10):
        state = nxt(state)
    x = [e for row in state for e in row]
    part1 = x.count("|") * x.count("#")
    table = dict()
    i = 10
    skip = False
    while i < 1000000000:
        h = hash(state)
        if h in table and not skip:
            i += ((1000000000 - i) // (i - table[h])) * (i - table[h])
            skip = True
        else:
            table[h] = i
        i += 1
        state = nxt(state)
    x = [e for row in state for e in row]
    part2 = x.count("|") * x.count("#")
    return part1, part2

def hash(state):
    return "\n".join("".join(row) for row in state)

def neigh(state, x, y):
    res = []
    for xx in range(x-1, x+2):
        if xx in range(size):
            for yy in range(y-1, y+2):
                if yy in range(size) and (xx != x or yy != y):
                    res.append(state[yy][xx])
    return res.count("."), res.count("|"), res.count("#")

def nxt(old):
    new = [list(x) for x in old]
    for x in range(size):
        for y in range(size):
            o, t, l = neigh(old, x, y)
            if old[y][x] == "." and t >= 3:
                new[y][x] = "|"
            if old[y][x] == "|" and l >= 3:
                new[y][x] = "#"
            if old[y][x] == "#" and (t < 1 or l < 1):
                new[y][x] = "."
    return new
run(solve)