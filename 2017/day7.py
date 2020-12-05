from aoc import *
from collections import Counter

def solve(inp):
    lines = [l.split(" -> ") for l in inp.splitlines()]
    ps = {l[0].split()[0]: (int(l[0].split()[1][1:-1]), l[1].split(", ") if len(l) > 1 else []) for l in lines}
    part1 = p1(ps)
    tree = construct(part1, ps)
    part2 = process(tree)
    return part1, part2
        

def p1(ps):
    keys = list(ps.keys())
    for key in ps:
        _, nex = ps[key]
        for n in nex:
            if n in keys:
                keys.remove(n)
    return keys[0]
    
def construct(base, data):
    w, nex = data[base]
    if not nex: 
        return (w, [])
    return w, [construct(n, data) for n in nex]

def value(tree):
    w, t = tree
    return w + sum(value(t1) for t1 in t)  if t else w

def process(tree, goal=0):
    w0, tree = tree
    if not tree:    
        return abs(w0-goal)
    vals = [value(t) for t in tree]
    mc = Counter(vals).most_common(1)[0][0]
    wrong = [t for t in tree if value(t) != mc]
    if not wrong:
        return abs(w0 + goal - value((w0, tree)))
    return process(wrong[0], mc)
    
    
    
    
    
    
    
    
    
run(solve)