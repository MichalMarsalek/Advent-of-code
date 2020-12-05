from aoc import *

def solve(inp):
    reg1 = {"a": 0, "b": 0, "c": 0, "d": 0}
    reg2 = {"a": 0, "b": 0, "c": 1, "d": 0}
    interpret(reg1, inp)
    interpret(reg2, inp)
    return reg1["a"], reg2["a"]

def interpret(reg, inp):
    code = [x.split() for x in inp.split("\n")]
    i = 0
    while i < len(code):
        ins, *arg = code[i]
        if ins == "jnz" and (reg[arg[0]] if arg[0].isalpha() else int(arg[0])) != 0:
            i += int(arg[1])
            continue
        if ins == "cpy":
            reg[arg[1]] = reg[arg[0]] if arg[0].isalpha() else int(arg[0])
        if ins == "inc":
            reg[arg[0]] += 1
        if ins == "dec":
            reg[arg[0]] -= 1
        i += 1

run(solve)