from aoc import *

def solve(inp):
    inp = inp.splitlines()
    n = len(inp[0])
    def slope(q,skip=1):
        res = 0
        for i,row in enumerate(inp[::skip]):
            res += row[q*i % n] == "#"
        return res
    part1 = slope(3)
    part2 = slope(1)*slope(3)*slope(5)*slope(7)*slope(1,2)    
    return part1, part2


run(solve)