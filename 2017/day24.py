from aoc import *

bridges = []

def strongest(end, comps, val=0, rec=0):
    valid = [c for c in comps if end in c]
    if valid:
        m = 0
        for c in valid:
            clone = list(c)
            clone.remove(end)
            nxt = clone[0]
            m = max(m, sum(c)+strongest(nxt, [x for x in comps if x != c], sum(c)+val, rec+1))     
        return m
    bridges.append((rec, val))
    return 0

def solve(inp):
    comps = [tuple(map(int, x.split("/"))) for x in inp.splitlines()]
    part1 = strongest(0, comps, 0, 0)
    
    part2 = max(bridges, key=lambda x: x[0]*10**6+x[1])[1]
    
    return part1, part2
        

run(solve)