from aoc import *
from collections import *
from asm import *

def solve(inp):
    #print(inp)
    inp = inp.splitlines()
    x, y = 0, 0
    dx, dy = 1, 0
    for c in inp:
        dir, amt = c[0], int(c[1:])
        if dir == 'N':
            y += amt
        elif dir == 'S':
            y -= amt
        elif dir == 'W':
            x -= amt
        elif dir == 'E':
            x += amt
        elif dir == 'L':
            for i in range(amt // 90):
                dx, dy = -dy, dx
        elif dir == 'R':
            for i in range(amt // 90):
                dx, dy = dy, -dx
        else:
            x += dx * amt
            y += dy * amt
    part1 = abs(x)+abs(y)
    
    x, y = 0, 0
    dx, dy = 10, 1
    for c in inp:
        dir, amt = c[0], int(c[1:])
        if dir == 'N':
            dy += amt
        elif dir == 'S':
            dy -= amt
        elif dir == 'W':
            dx -= amt
        elif dir == 'E':
            dx += amt
        elif dir == 'L':
            for i in range(amt // 90):
                dx, dy = -dy, dx
        elif dir == 'R':
            for i in range(amt // 90):
                dx, dy = dy, -dx
        else:
            x += dx * amt
            y += dy * amt
    part2 = abs(x)+abs(y)
    return part1, part2


run(solve)