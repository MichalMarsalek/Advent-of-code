from aoc import *
from collections import defaultdict

    def solve(inp):
        inp = inp.replace("inc ", "").replace("dec ", "-").replace("--", "")
        reg = defaultdict(int)
        inss = [i.split() for i in inp.splitlines()]
        part2 = 0
        for ins in inss:
            n, d, _, e, r, v = ins
            d = int(d)
            v = int(v)
            funcs = {
            ">": lambda a, b: reg[a] > b,
            "<": lambda a, b: reg[a] < b,
            ">=": lambda a, b: reg[a] >= b,
            "<=": lambda a, b: reg[a] <= b,
            "==": lambda a, b: reg[a] == b,
            "!=": lambda a, b: reg[a] != b
            }
            if funcs[r](e, v):
                reg[n] += d
                part2 = max(reg[n], part2)
        part1 = max(reg.values())
        return part1, part2
        

run(solve)