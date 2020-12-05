from aoc import *
from collections import *

def val(n, reg):
    try:
        return int(n)
    except:
        return reg[n]
def solve(inp):
    part1 = 0
    inss = [x.split(" ") for x in inp.splitlines()]
    i = 0
    regs = defaultdict(int)
    regs["a"] = 1
    while i in range(len(inss)):
        cmd, x, y = inss[i]
        if cmd == "set":
            regs[x] = val(y, regs)
        elif cmd == "sub":
            regs[x] -= val(y, regs)
        elif cmd == "mul":
            regs[x] *= val(y, regs)
            part1 += 1
        elif cmd == "jnz" and val(x, regs) != 0:
            i += val(y, regs)
            continue
        if x == "h":
            print(regs["h"])
        i += 1
    
    part2 = 0
    return part1, part2
        

run(solve)