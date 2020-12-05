from aoc import *

def solve(inp):
    next = tuple([int(x) for x in inp.split("\t")])
    part1, next = count_redistributions(next)
    part2, _ = count_redistributions(next)
    return part1, part2

def count_redistributions(next):
    seen = []
    while next not in seen:
        seen.append(next)
        next = redistribute(next)
    return len(seen), next

def redistribute(conf):
    conf = list(conf)
    l = len(conf)
    ci = max(range(l), key=lambda i: conf[i])
    val = conf[ci]
    conf[ci] = 0
    while val:
        ci = (ci+1) % l
        conf[ci] += 1
        val -= 1
    return tuple(conf)


run(solve)