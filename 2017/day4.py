from aoc import *

def solve(inp):
    part1 = sum(unique(p.split(" ")) for p in inp.splitlines())    
    part2 = sum(unique(["".join(sorted(w)) for w in p.split(" ")]) for p in inp.splitlines())
    return part1, part2
        
def unique(p):
    return len(set(p)) == len(p)

run(solve)