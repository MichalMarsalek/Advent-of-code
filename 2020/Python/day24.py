from aoc import *
from collections import *
from asm import *

DIR = {"e":(1,0), "w":(-1,0), "sw":(0,-1), "se":(+1,-1), "nw":(-1,+1), "ne":(0,+1)}

def get_moves(line):
    i = 0
    while i < len(line):
        if line[i] in "we":
            yield line[i]
            i += 1
        else:
            yield line[i:i+2]
            i += 2

def nxt(grid):
    counting = defaultdict(int)
    result = set()
    for x,y in grid:
        for dx, dy in DIR.values():
            counting[x+dx,y+dy] += 1
    for tile,count in counting.items():
        if count == 2 or (tile in grid and count == 1):
            result.add(tile)
    return result

def solve(inp):
    data = inp.splitlines()
    black = defaultdict(bool)
    for line in data:
        x = 0
        y = 0
        for move in get_moves(line):
            dx, dy = DIR[move]
            x += dx
            y += dy
        black[x,y] ^= True
    part1 = sum(black.values())
    grid = {k for k,v in black.items() if v}
    for _ in range(100):
        grid = nxt(grid)
    part2 = len(grid)
    return part1, part2

run(solve)