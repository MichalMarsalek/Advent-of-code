from aoc import *
from collections import *
from IntCode import *
from random import *

def solve(code):
    pc = IntCode(code)
    grid = defaultdict(int)
    pos = 0 + 0j
    dirs = {1j:1, -1j:2, -1:3, 1:4}
    grid[pos] = -4 #start
    d = 1
    for k in range(10000):
        if k > 20 and pos == 0:
            print(k)
            break
        o = pc.run(dirs[d]).pop(0)
        if o == 0:
            grid[pos + d] = -8 #wall
            d *= 1j
        elif o == 1:
            pos += d
            d *= -1j
        elif o == 2:
            pos += d
            d *= -1j
            grid[pos] = -2 #goal
            system = pos
    dist = [[0+0j]]
    found = set()
    part1 = None
    for i in ints():
        dist.append([])
        if part1:
            break
        for p in dist[i-1]:
            for d in dirs.keys():
                if grid[p+d] == -2:
                    part1 = i
                    break
                if grid[p+d] == 0 and  p+d not in found:
                    dist[i].append(p+d)
                    found.add(p+d)
    dist = [[system]]
    found = set()
    for i in ints():
        if not dist[i-1]:
            break
        dist.append([])
        for p in dist[i-1]:
            for d in dirs.keys():
                if grid[p+d] == 0 and  p+d not in found:
                    dist[i].append(p+d)
                    found.add(p+d)
    part2 = i-2
    return part1, part2
    

        


run(solve)