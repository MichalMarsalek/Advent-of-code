from aoc import *
from collections import *
from IntCode import * 

def solve(code):
    pcs = [IntCode(code) for _ in range(50)]
    for i in range(50):
        pcs[i].run(i,-1)
    part1 = part2 = None
    i = 0
    idle = 0
    last_y = None
    while True:
        if idle >= 50:
            pcs[0].run(*NAT)
            if last_y == NAT[1]:
                part2 = last_y
                break
            last_y = NAT[1]
            idle = 0
        if pcs[i].out:
            id, x, y = pcs[i].get_vector(3)
            if id == 255:
                if not part1:
                    part1 = y
                NAT = x, y
            else:    
                pcs[id].run(x,y)
            idle = 0
        else:
            idle += 1
        i = (i+1) % 50
            
    
    return part1, part2      

run(solve)
