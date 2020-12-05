from aoc import *
from collections import *


def is_integer(n):
    try:
        int(n)
        return True
    except:
        return False

def val(n, reg):
    try:
        return int(n)
    except:
        return reg[n]

def solve1(inp):
    inss = inp.splitlines()
    i = 0
    regs = defaultdict(int)
    sound = 0
    while i in range(len(inss)):
        ins = inss[i].split()
        if len(ins) == 2:
            cmd, a = ins
            if cmd == "snd":
                sound = val(a, regs)
            elif val(a, regs) != 0:
                return sound
        else:
            cmd, x, y = ins
            if cmd == "set":
                regs[x] = val(y, regs)
            elif cmd == "add":
                regs[x] += val(y, regs)
            elif cmd == "mul":
                regs[x] *= val(y, regs)
            elif cmd == "mod":
                regs[x] %= val(y, regs)
            elif val(x, regs) > 0:
                i += val(y, regs)
                continue
        i += 1            
    
    part2 = None
    return part1, part2

def solve2(inp):
    inss = inp.splitlines()
    regs0 = defaultdict(int)
    regs1 = defaultdict(int)
    regs1["p"] = 1
    running0 = running1 = True
    ai = bi = 0
    aq = deque()
    bq = deque()
    res = 0
    while running0 or running1:
        running0 = False
        if ai in range(len(inss)):
            running0 = True
            ins = inss[ai].split()
            if len(ins) == 2:
                cmd, a = ins
                if cmd == "snd":
                    bq.append(val(a, regs0))
                elif aq:
                    regs0[a] = aq.popleft() 
                else:
                    running0 = False
            else:
                cmd, x, y = ins
                if cmd == "set":
                    regs0[x] = val(y, regs0)
                elif cmd == "add":
                    regs0[x] += val(y, regs0)
                elif cmd == "mul":
                    regs0[x] *= val(y, regs0)
                elif cmd == "mod":
                    regs0[x] = regs0[x] % val(y, regs0)
                elif val(x, regs0) > 0:
                    ai += val(y, regs0)-1
            if running0:
                ai += 1
        running1 = False
        if bi in range(len(inss)):
            running1 = True
            ins = inss[bi].split()
            if len(ins) == 2:
                cmd, a = ins
                if cmd == "snd":
                    aq.append(val(a, regs1))
                    res += 1
                elif bq:
                    regs1[a] = bq.popleft()     
                else:
                    running1 = False
            else:
                cmd, x, y = ins
                if cmd == "set":
                    regs1[x] = val(y, regs1)
                elif cmd == "add":
                    regs1[x] += val(y, regs1)
                elif cmd == "mul":
                    regs1[x] *= val(y, regs1)
                elif cmd == "mod":
                    regs1[x] = regs1[x] % val(y, regs1)
                elif val(x, regs1) > 0:
                    bi += val(y, regs1)-1
            if running1:
                bi += 1
    return res

def solve(inp):
    return solve1(inp), solve2(inp)
run(solve, "day18")