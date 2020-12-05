from aoc import *
from collections import Counter

def solve(inp):
    inp = inp.splitlines()
    a=b=0
    for line in inp:
        line = Counter(line)
        a += any(line[a] == 2 for a in set(line))
        b += any(line[a] == 3 for a in set(line))
    part1 = a*b
    for a in inp:
        for b in inp:
            for i in range(len(a)):
                if a[:i]+a[i+1:] == b[:i]+b[i+1:] and a!= b:
                    part2 = a[:i]+a[i+1:]
    return part1, part2


run(solve)