from aoc import *
from collections import *
from asm import *

def valid(rule, v):
    a,b,c,d=introw(rule)
    return v in range(a,b+1) or v in range(c, d+1)

def solve(inp):
    inp = inp.replace("-", ":")
    rules, my, nearby = inp.split("\n\n")
    rules = [x.split(": ") for x in rules.split("\n")]
    rules = {k:v for k,v in rules}
    my = introw(my.split("\n")[1])
    nearby = intgrid(nearby)[1:]    
        
    part1 = 0
    for ticket in nearby:
        for v in ticket:
            if not any(valid(field, v) for field in rules.values()):
                part1 += v
    valids = []
    for ticket in nearby:
        if all(any(valid(field, v) for field in rules.values()) for v in ticket):
            valids.append(ticket)
    mapping = defaultdict(set)
    for k,r in rules.items():
        for i in range(len(valids[0])):
            if all(valid(r, t[i]) for t in valids):
                mapping[k].add(i)
    placed = set()
    while len(placed) < len(valids[0]):
        for inds in mapping.values():
            if len(inds) == 1:
                placed |= inds
        mapping = {k:(v if len(v) == 1 else v - placed) for k,v in mapping.items()}
    part2 = product(my[list(ind)[0]] for f, ind in mapping.items() if f.startswith("departure"))
    return part1, part2


run(solve)