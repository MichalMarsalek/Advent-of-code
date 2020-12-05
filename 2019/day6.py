from aoc import *
from collections import *

def solve(inp):
    inp = inp.splitlines()
    inp = [x.split(")") for x in inp]
    map = {b: a for a,b in inp}
    part1 = 0
    trace = {}
    trace["COM"] = []
    def t(sat):
        if sat not in trace:
            trace[sat] = t(map[sat]) + [sat]
        return trace[sat]
    for k in map:
        part1 += len(t(k))
    
    a = trace["YOU"]
    b = trace["SAN"]
    while a[0] == b[0]:
        a = a[1:]
        b = b[1:]
    part2 = len(a) + len(b) - 2
    return part1, part2

run(solve)