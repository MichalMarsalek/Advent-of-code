from aoc import *
from collections import *

def solve(inp):
    ser = int(inp)
    ser = 18
    part1 = 0
    vals = [[value(x, y, ser) for y in range(301)] for x in range(301)]
    sums = [301*[0] for _ in range(301)]
    for y in range(1, 301):
        for x in range(1, 301):
            sums[x][y] = sums[x-1][y] + sums[x][y-1] - sums[x-1][y-1] + value(x,y,ser)
    return vals[34][47]
    for i in vals[:10]:
        print(i)
    print()
    for i in sums[:10]:
        print(i)
    maxval1 = 0
    maxval2 = 0
    part2 = 0
    for size in range(1, 300):
        for x in range(1, 302-size):
            for y in range(1, 302-size):
                val = sums[x+size-1][y+size-1] - sums[x-1][y+size-1] - sums[x+size-1][y-1] + sums[x-1][y-1]
                if size == 3 and x == 33 and y == 45:
                    print(val)  
                if val > maxval2:
                    part2 = x, y, size
                    maxval2 = val
                if size == 3 and val > maxval1:
                    part1 = x, y
                    maxval1 = val
    return part1, part2

def value(x, y, ser):
    a = x + 10
    a *= y
    a += ser
    a *= (x+10)
    a //= 100
    a %= 10
    a -= 5
    return a

run(solve)