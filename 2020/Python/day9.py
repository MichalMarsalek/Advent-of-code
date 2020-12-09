from aoc import *
import numpy as np

def solve(inp):
    def ok(n, arr):
        return any(n-a in arr-{a} for a in arr)
    inp = intcolumn(inp)
    N = len(inp)
    for i in range(25, N):
        if not ok(inp[i], set(inp[i-25:i])):
            part1 = inp[i]
            break
    cumsum = np.cumsum(inp)
    for j in range(N):
        for i in range(j):
            if cumsum[j] - cumsum[i] == part1:
                part2 = min(inp[i+1:j+1])+max(inp[i+1:j+1])
                return part1, part2

run(solve)