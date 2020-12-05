from aoc import *
from day10 import hash
from collections import *

S = 256
def solve(inp):
    #return hash(""), hash("AoC 2017"), hash("1,2,3"), hash("1,2,4")
    part1 = 0
    grid = list()
    for i in range(128):
        h = hash(inp + "-" + str(i))
        #print(h)
        r = bin(int(h, 16))[2:].zfill(128)
        #if i < 8:
        #    print(h)
        #    print(r)
        part1 += sum(int(c) for c in r)
        grid.append([-int(c) for c in r])
    part2 = 0
    def flood(x0, y0):
        q = deque()
        q.append((x0, y0))
        while q:
            x, y = q.pop()
            grid[y][x] = part2
            for nx, ny in neigbours4(x, y):
                if nx in range(128) and ny in range(128):
                    if grid[ny][nx] == -1:
                        q.append((nx, ny))
    for y in range(128):
        for x in range(128):
            if grid[y][x] == -1:
                part2 += 1
                flood(x, y)
    for i in range(8):
        print(grid[i])
    return part1, part2

run(solve)