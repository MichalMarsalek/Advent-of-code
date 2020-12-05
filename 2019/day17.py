from aoc import *
from collections import *
from IntCode import *
from random import *

def solve(code):
    pc = IntCode(code)
    pc.run()
    lines = pc.get_text().splitlines()
    h = len(lines)-1
    w = len(lines[0])
    
    d= [(-1,0),(0,0),(1,0), (0,1), (0,-1)]
    part1 = 0
    for y in range(1,h-2):
        for x in range(1,w-1):            
            if all(lines[y+dy][x+dx] == "#" for dx,dy in d):
                part1 += x*y
    p = "L,8,R,10,L,10,R,10,L,8,L,8,L,10,L,8,R,10,L,10,L,4,L,6,L,8,L,8,R,10,L,8,L,8,L,10,L,4,L,6,L,8,L,8,L,8,R,10,L,10,L,4,L,6,L,8,L,8,R,10,L,8,L,8,L,10,L,4,L,6,L,8,L,8"
    A = "L,8,R,10,L,10"
    B = "R,10,L,8,L,8,L,10"
    C = "L,4,L,6,L,8,L,8"
    p = p.replace(A, "A").replace(B,"B").replace(C, "C")
    pc = IntCode(code)
    pc[0] = 2
    pc.console(p)
    pc.console(A)
    pc.console(B)
    pc.console(C)
    pc.console("n") 
    part2 = pc.out[0]
    return part1, part2
    

        


run(solve)