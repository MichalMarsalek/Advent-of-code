from aoc import *

def sumtree(t):
    ch = t.pop(0)
    md = t.pop(0)
    return sum(sumtree(t) for _ in range(ch)) + sum(t.pop(0) for _ in range(md))

def val(t):
    ch = t.pop(0)
    md = t.pop(0)
    vals = [val(t) for _ in range(ch)]
    mdata = [t.pop(0) for _ in range(md)]
    if ch == 0:
        return sum(mdata)
    return sum(vals[i-1] for i in mdata if i-1 in range(ch))

def solve(inp):
    part1 = sumtree(introw(inp))
    part2 = val(introw(inp))
    return part1, part2

run(solve)