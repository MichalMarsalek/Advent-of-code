from aoc import *

def solve(inp):
    pos = 0 + 0j
    seen = set([pos])
    dir = 1j
    part2 = None
    for ins in inp.split(", "):
        r, move = ins[0], int(ins[1:])
        dir *= 1j if r == "L" else -1j
        for i in range(move):
            pos += dir
            if part2 is None and pos in seen:
                part2 = manhattan(pos)
            seen.add(pos)
    part1 = manhattan(pos)
    return part1, part2
    
run(solve)