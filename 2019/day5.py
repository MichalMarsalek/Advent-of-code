from aoc import *
from collections import *
from IntCode import *

def solve(code):
    part1 = IntCode(code).run(1)[-1]
    part2 = IntCode(code).run(5)[-1]
    return part1, part2

run(solve)