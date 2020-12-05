from aoc import *

def solve(inp):
    lines = inp.splitlines()
    lines = [[int(x) for x in line.split("\t")] for line in lines]
    part1 = sum(max(line) - min(line) for line in lines)
    part2 = sum(divis(line) for line in lines)
    return part1, part2

def divis(line):
    for n in line:
        for m in line:
            if m != n and (m % n == 0 or n % m == 0):
                return max(m,n) // min(m, n)

run(solve)