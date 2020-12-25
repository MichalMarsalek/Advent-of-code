from aoc import *

def dlog(base, val, mod):
    v = 1
    for x in range(mod):
        if v == val:
            return x
        v = v*base % mod
    

def solve(inp):
    mod = 20201227
    a,b = intcolumn(inp)
    return pow(a,dlog(7,b,mod), mod)

run(solve)