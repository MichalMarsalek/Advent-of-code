from aoc import *
from collections import *

def solve(inp):
    print(inp)
    #inp = intgrid(inp)    
    part1 = part2 = 0
    for i in range(147981,691424):
        istr = str(i)
        if all(a<=b for a,b in zip(list(istr), list(istr)[1:])):
            if any(str(j)+str(j) in istr for j in range(10)):
                if m(istr):
                    part2 += 1
                part1 += 1
    return part1, part2

def m(p):
    p = list("#"+p+"#")
    if any(a!=b and b== c and c!= d for a,b,c,d in zip(p, p[1:], p[2:],p[3:])):
        return True
        


run(solve)