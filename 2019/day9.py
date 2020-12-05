from aoc import *
from collections import *
from IntCode import *

def solve(code):
    part1 = IntCode(code).run(1)[0]
    part2 = IntCode(code).run(2)[0]
    return part1, part2
 



run(solve)