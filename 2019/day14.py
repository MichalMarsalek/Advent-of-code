from aoc import *
from collections import *
from IntCode import *
from math import ceil

class Chemical:
    def __init__(self, s):
        a, n = s.split(" ")
        self.amount = int(a)
        self.name = n

class Reaction:
    def __init__(self, s):
        self.s = s
        inp, res = s.split(" => ")
        self.inputs = [Chemical(x) for x in inp.split(", ")]
        self.result = Chemical(res)
    def __str__(self):
        return self.s

def solve(inp):
    part1 = produce_fuel(inp, 1)
    
    for i in ints(0,10000):            
        ore = produce_fuel(inp, i)  
        if ore > 1000000000000:
            break
    for i in ints(i-10000):            
        ore = produce_fuel(inp, i)  
        if ore > 1000000000000:
            break
    part2 = i-1
    return part1, part2

def produce_fuel(inp, amount):
    reactions = [Reaction(x) for x in inp.splitlines()]
    reactions = {x.result.name: x for x in reactions}
    chems = list(reactions.keys())
    order = ["ORE"]
    known = set(order)
    while chems:
        ch = chems.pop(0)
        if all(i.name in known for i in reactions[ch].inputs):
            order.append(ch)
            known.add(ch)
        else:
            chems.append(ch)
    needed = defaultdict(int)
    needed["FUEL"] = amount
    for ch in order[-1:0:-1]:
        r = reactions[ch]
        repet = ceil(needed[ch] / r.result.amount)
        for i in r.inputs:
            needed[i.name] += i.amount * repet
    return needed["ORE"]


run(solve)