from aoc import *
from collections import *
from asm import *
from itertools import product

def solve(inp):
    inp = inp.replace("mask", "-1").replace("mem[", "").replace("] ", "").replace("=", "")
    data1 = grid(inp)
    memory = defaultdict(int)
    part1 = 0
    #print(data1)
    for a,b in data1:
        a = int(a)
        if a == -1:
            mask = b
        else:
            memory[a] = int(b)
            for i in range(36):
                if mask[-i-1] == "0":
                    memory[a] ^= (1 << i)&memory[a]
                if mask[-i-1] == "1":
                    memory[a] ^= (1 << i)&(~memory[a])
    part1 = sum(memory.values())
    memory = defaultdict(int)
    for a,b in data1:
        a = int(a)
        if a == -1:
            mask = b
        else:
            adress = list("{0:036b}".format(a))
            #print("".join(adress))
            Xs = []
            #print(mask)
            for i in range(36):
                if mask[i] != "0":
                    adress[i] = mask[i]
                if mask[i] == "X":
                    Xs.append(i)
            #print("".join(adress))
            for float in product("01", repeat=len(Xs)):
                adress2 = list(adress)
                for i, bit in enumerate(float):
                    adress2[Xs[i]] = bit
                #print("f", "".join(adress2))
                adress2 = int("".join(adress2), base=2)
                memory[adress2] = b
            #print()
            
    part2 = sum(memory.values())
    return part1, part2


run(solve)