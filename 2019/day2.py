from aoc import *
from collections import *

def solve(inp):
    inp = introw(inp)
    part1 = calc(inp, 12, 2)
    for n in range(100):
        for v in range(100):
            if calc(inp, n, v) == 19690720:
                part2 = 100*n + v
    return part1, part2

def calc(inp, n, v):
    inp = list(inp)
    inp[1] = n
    inp[2]=v
    i = 0
    while True:
        if inp[i] == 99:
            break
        if inp[i] == 1:
            inp[inp[i+3]] = inp[inp[i+1]] + inp[inp[i+2]]
        if inp[i] == 2:
            inp[inp[i+3]] = inp[inp[i+1]] * inp[inp[i+2]]
        i += 4
    return inp[0]

run(solve)