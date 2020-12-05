from aoc import *
from collections import *

def solve(inp):
    parta, partb = inp.split("\n\n\n\n")
    partb = intgrid(partb)
    examples = parta.split("\n\n")
    part1 = sum(len(match_codes(e)) >= 3 for e in examples)
    possibilities = [set(range(16)) for _ in range(16)]
    for ex in examples:
        bef, ins, af = intgrid(ex)
        possibilities[ins[0]] &= set(match_codes(ex))
    for _ in range(16):
        for i in range(16):
            if len(possibilities[i]) == 1:
                for j in range(16):
                    if j != i:
                        possibilities[j] -= possibilities[i]
    regs = [0,0,0,0]
    for ins in partb:
        ins[0] = list(possibilities[ins[0]])[0]
        regs = execute(regs, *ins)
    part2 = regs[0]
    return part1, part2

def execute(registers, ins, a, b, c):
    registers = list(registers)
    if ins not in (13,9,10):
        a = registers[a]
    if ins in (0,2,4,6,10,12,13,15):
        b = registers[b]
    if ins < 2:
        registers[c] = a + b
    elif ins < 4:
        registers[c] = a * b
    elif ins < 6:
        registers[c] = a & b
    elif ins < 8:
        registers[c] = a | b
    elif ins < 10:
        registers[c] = a
    elif ins < 13:
        registers[c] = int(a > b)
    else:
        registers[c] = int(a == b)
    return registers

def match_code(ex, op):
    bef, ins, af = intgrid(ex)
    ins[0] = op
    return af == execute(bef, *ins)

def match_codes(ex):
    return [i for i in range(16) if match_code(ex, i)]
    

run(solve)