from aoc import *

def solve(inp):
    ranges = [tuple(map(int, row.split("-"))) for row in inp.split("\n")]
    return solve1(ranges), solve2(ranges)
    

def solve2(ranges):
    cnt = 4294967296
    i = -2
    while True:
        nxt = list(filter(lambda x: x[0] > i+1, ranges))
        if not nxt:
            break
        A,B = min(nxt, key=lambda x: x[0])
        while True:
            overlaps = list(filter(lambda x: x[0]-1 <= B and x[1] > B, ranges))
            if overlaps:
                a,B = max(overlaps, key=lambda x: x[1])
            else:
                break
        i = B
        cnt += -B + A - 1
    return cnt
            
            

def solve1(ranges):
    mini = 0
    while True:
        for a,b in ranges:
            if a <= mini and mini <= b:
                mini = b+1
                break
        else:
            break
    return mini

run(solve)