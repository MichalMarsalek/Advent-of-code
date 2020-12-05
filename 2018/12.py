from aoc import *
from collections import *

def solve(inp):
    init, ruls = inp.split("\n\n")
    init = init.replace("initial state: ", "")
    rules = {}
    for rule in ruls.splitlines():
        key, val = rule.split(" => ")
        rules[key] = val
    pots = defaultdict(lambda: ".")
    for i in range(100):
        pots[i] = init[i]
    for _ in range(20):
        pots = nxt(pots, rules)
    part1 = sum(i for i in range(-20, 121) if pots[i] == "#")
    pots = defaultdict(lambda: ".")
    for i in range(100):
        pots[i] = init[i]
    i, flowers = stabilize(pots, rules)
    part2 = sum(flowers) + (50*10**9-i) * len(flowers)
    #part2b = 
    return part1, part2

def stabilize(pots, rules):
    for i in range(1,50*10**9):
        pots = nxt(pots, rules)
        if pots[290] == "#":
            flowers = [i for i in range(-200, 300) if pots[i] == "#"]
            return i, flowers

def nxt(pots, rules):
    res = defaultdict(lambda: ".")
    for i in range(-100, 400):
        res[i] = rules["".join(pots[j] for j in range(i-2, i+3))]
    return res
    


run(solve)