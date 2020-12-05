from aoc import *
import itertools
from collections import deque

def solve(inp):
    lab = [list(x) for x in inp.split("\n")]
    max_i = 0
    while any(str(max_i+1) in row for row in lab):
        max_i += 1
    coords = [find_coords(lab, n) for n in range(max_i+1)]
    distances = [[bfs_from_to(lab, a, b) for b in coords] for a in coords]
    part1 = min(sum(distances[a][b] for a, b in zip(perm, perm[1:])) for perm in permutations(max_i))
    part2 = min(sum(distances[a][b] for a, b in zip(perm, perm[1:])) for perm in permutations(max_i, True))
    return part1, part2

def permutations(max_i, ret = False):
    return [[0] + list(perm) + ([0] if ret else []) for perm in itertools.permutations(range(1, max_i+1))]

def find_coords(lab, n):
    for y in range(len(lab)):
        if str(n) in lab[y]:
            break
    x = lab[y].index(str(n))
    return x, y

def bfs_from_to(mp, fr, to):
    q = deque([(0, fr)])
    vis = set([fr])
    while q:
        dst, cur = q.pop()
        if cur == to:
            return dst
        x, y = cur
        moves = [(-1, 0), (1, 0), (0, 1), (0, -1)]
        for dy, dx in moves:
            ny, nx = y + dy, x + dx
            if mp[ny][nx] != '#' and (nx, ny) not in vis:
                q.appendleft((dst+1, (nx, ny)))
                vis.add((nx, ny))
    return -1

run(solve)