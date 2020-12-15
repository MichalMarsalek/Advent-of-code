from aoc import *

def play(start, n):
    hist = {a:i for i,a in enumerate(start[:-1])}
    last = start[-1]
    for i in range(len(start), n):
        if last not in hist:
            new = 0
        else:
            new = i - hist[last]-1
        hist[last] = i-1
        last = new
    return last

def solve(inp):
    data = introw(inp)
    part1 = play(data, 2020)
    part2 = play(data, 30000000)
    return part1, part2


run(solve)