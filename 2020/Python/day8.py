from aoc import *
from asm import *

def solve(inp):
    program = Asm(inp)
    _, part1 = program.run()
    for j in range(len(program.code)):
        program2 = Asm(program)
        if program[j][0] == "jmp":
            program2[j] = ("nop", program[j][1])
        elif program[j][0] == "nop":
            program2[j] = ("jmp", program[j][1])        
        type, part2 = program2.run()
        if type == "out":
            break
    return part1, part2

run(solve)