from aoc import *
from collections import *
from asm import *

def solve(inp):
    inp = sorted(intcolumn(inp))
    inp = [0] + inp + [max(inp)+3]
    difs = defaultdict(int)
    for a,b in zip(inp, inp[1:]):
        difs[b-a]+=1
    part1 = difs[1] * difs[3]
    
    DP = defaultdict(int)
    DP[0] = 1
    for a in inp[1:]:
        DP[a] = DP[a-1] + DP[a-2] + DP[a-3]
    part2 = DP[max(inp)]
    return part1, part2


run(solve)

for n in range(10):
    print(2**n - max(0, (n-3)*(n-2)/2))