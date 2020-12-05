from aoc import *

def solve(inp):
    reg = {"a": 7, "b": 0, "c": 0, "d": 0}
    #interpret(reg, inp)
    part1 = reg["a"]
    reg = {"a": 12, "b": 0, "c": 0, "d": 0}
    interpret(reg, inp)
    part2 = reg["a"]
    return part1, part2

def interpret(reg, inp):
    code = [x.split() for x in inp.split("\n")]
    i = 0
    while i < len(code):
        #print(i, code, reg)
        ins, *arg = code[i]
        if ins == "tgl":
            s = i + reg[arg[0]] if arg[0].isalpha() else int(arg[0])
            if s in range(len(code)):
                if len(code[s]) == 2:
                    code[s] = ("dec" if code[s][0] == "inc" else "inc"), code[s][1]
                elif len(code[s]) == 3:
                    code[s] = ("cpy" if code[s][0] == "jnz" else "jnz"), code[s][1], code[s][2]
                for l in code:
                    print(l)
                print()
        if ins == "jnz" and (reg[arg[0]] if arg[0].isalpha() else int(arg[0])) != 0:
            i += reg[arg[1]] if arg[1].isalpha() else int(arg[1 ])
            continue
        if ins == "cpy":
            reg[arg[1]] = reg[arg[0]] if arg[0].isalpha() else int(arg[0])
        if ins == "inc":
            reg[arg[0]] += 1
        if ins == "dec":
            reg[arg[0]] -= 1
        i += 1
            

run(solve)