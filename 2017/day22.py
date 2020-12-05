from aoc import *

def solve(inp):
    inp = inp.splitlines()
    grid = [[False for _ in range(1001)] for _ in range(1001)]
    mid = 500
    size = 25//2
    for y, line in enumerate(inp):
        for x, c in enumerate(line):
            grid[y+mid-size][x+mid-size] = c=="#"
    x, y = mid, mid
    dx, dy = 0, -1
    part1 = 0
    for _ in range(1):
        if grid[y][x]:
            dx, dy = -dy, dx
        else:
            dx, dy = dy, -dx
            part1 += 1
        grid[y][x] = not grid[y][x]
        x += dx
        y += dy
    
    grid = [[False for _ in range(5001)] for _ in range(5001)]
    mid = 2500
    size = 25//2
    #size = 1
    for y, line in enumerate(inp):
        for x, c in enumerate(line):
            grid[y+mid-size][x+mid-size] = 2*int(c=="#")
    x, y = mid, mid
    dx, dy = 0, -1
    part2 = 0
    for i in range(10000000):
        #if(i % 1):
        #    print(i)
        #print(x, y)
        if grid[y][x] == 0:
            dx, dy = dy, -dx
        elif grid[y][x] == 1:            
            part2 += 1
        elif grid[y][x] == 2:
            dx, dy = -dy, dx
        elif grid[y][x] == 3:
            dx, dy = -dx, -dy
        grid[y][x] = (grid[y][x]+1) % 4
        x += dx
        y += dy
    return part1, part2
        

run(solve)