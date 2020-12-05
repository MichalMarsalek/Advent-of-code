from aoc import *
from collections import *
from IntCode import *

def solve(inp):
    return part1(inp), part2(inp)

def part1(code):
    grid = defaultdict(int)
    out = IntCode(code).run()
    while out:
        x, y, id = out[:3]
        out = out[3:]
        grid[x + y*1j] = id
    return sum(grid[x] == 2 for x in grid)

def part2(code):
    pc = IntCode(code)
    pc[0] = 2
    score = 0
    paddlex = ballx = 0
    pc.run()
    while not pc.halted:
        while pc.out:
            x, y, id = pc.get_vector(3)
            if (x,y) == (-1,0):
                score = id
            elif id == 4:
                ballx = x
            elif id == 3:
                paddlex = x
        if paddlex == ballx:
            pc.run(0)
        elif paddlex < ballx:
            pc.run(1)
        else:
            pc.run(-1)
        
    return score
        


run(solve)