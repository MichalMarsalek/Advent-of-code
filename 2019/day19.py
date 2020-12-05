from aoc import *
from collections import *
from IntCode import *
from random import *

def solve(code):
    t = lambda x,y: IntCode(code).run(x,y)[0]
    part1 = sum(t(x,y) for x in range(50) for y in range(50))
        
    hrange = [(0,1),(0,0), (0,0), (4,5)]
    for x in ints(4):
        y1, y2 = hrange[x-1]
        while t(x,y1) == 0:
            y1 += 1
        while t(x,y2) == 1:
            y2 += 1
        hrange.append((y1, y2))
        if x > 200 and y1 + 99 < hrange[x-99][1]:
            part2 = (x-99)*10000 + y1
            break
    return part1, part2      

run(solve)