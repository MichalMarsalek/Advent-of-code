from aoc import *
from collections import *
from IntCode import *

def solve(code):
    pc = IntCode(code)
    pc.console("""NOT A T
OR T J
NOT B T
OR T J
NOT C T
OR T J
AND D J
WALK""")
    part1 = pc.out[0]
    
    pc = IntCode(code)
    pc.console("""NOT A T
OR T J
NOT B T
OR T J
NOT C T
OR T J
AND D J
NOT T T
OR E T
OR H T
AND T J
RUN""")
    part2 = pc.out[0]    
    return part1, part2      

run(solve)
