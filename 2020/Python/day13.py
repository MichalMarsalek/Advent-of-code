from aoc import *
from collections import *
from asm import *

def solve(inp):
    earliest, buses = inp.splitlines()
    earliest, buses = int(earliest), buses.split(",")
    buses = [(-i,int(b)) for i,b in enumerate(buses) if b != "x"]
    part1 = min(buses, key=lambda b:-earliest % b[1])[1]
    part1 *= -earliest % part1
    part2 = crt(buses)
    return part1, part2

run(solve)