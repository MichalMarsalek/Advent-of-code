from aoc import *

def solve(inp):
    ins = [int(x) for x in inp.splitlines()]
    part1 = process(ins, lambda x: x+1)
    part2 = process(ins, lambda x: x-1 if x > 2 else x+1)
    return part1, part2
        
def process(ins, transformation):
    ins = list(ins)
    i = 0
    res = 0
    while 0 <= i and i < len(ins):
        t = ins[i]
        ins[i] = transformation(ins[i])
        i += t
        res += 1
    return res

run(solve)