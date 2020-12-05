from aoc import *
from collections import *

def solve(inp):
    events = sorted(inp.splitlines())
    guards = Counter()
    sleeping = defaultdict(Counter)
    g = None
    for e in events:
        _,_,m,_,t,*_=multisplit(e, ":]#")
        m = int(m)
        if t == "asleep":
            gs = m
        elif t == "up":
            for min in range(gs, m):
                sleeping[g][min] += 1
        else:
            g = int(t)
    most_key1 = None
    most_val1 = 0
    most_key2 = None
    most_val2 = 0
    for g in sleeping:
        mkey, mval = sleeping[g].most_common(1)[0]
        if mval > most_val1:
            most_val1 = mval
            most_key1 = g, mkey
        val = sum(v for v in sleeping[g].values())
        if val >= most_val2:
            most_val2 = val
            most_key2 = g
    part1 = most_key2*sleeping[most_key2].most_common(1)[0][0]
    part2 = most_key1[0]*most_key1[1]
    return part1, part2


run(solve)