from aoc import *
from collections import *
from string import ascii_lowercase

def solve(inp):
    coords = intgrid(inp)
    areas = defaultdict(int)
    distances = dict()
    padd=100
    r = range(-padd, 400+padd)
    for x in r:
        for y in r:
            distances[(x,y)] = len(coords)*[0]
            for i, (xx, yy) in enumerate(coords):
                    distances[(x,y)][i] = abs(x-xx) + abs(y-yy)
    for x in r:
        for y in r:
            mini = min(distances[(x,y)])
            nodes = [i for i in range(len(coords)) if distances[(x,y)][i] == mini]
            if len(nodes) == 1:
                areas[nodes[0]] += 1
                if x in (-padd,399+padd) or y in (-padd,399+padd):
                    areas[nodes[0]] += 10**6
    areas = sorted(areas.items(), key=lambda x: -x[1])
    part1 = next(a for i, a in areas if a < 10**6)
    part2 = sum(1 for x in r for y in r if sum(distances[(x,y)]) < 10000)
    return part1, part2

run(solve)