from aoc import *
from collections import *
from IntCode import *

def solve(code):
    part1 = 0
    for a,b,c,d,e in permutations(range(5)):
        io1, io2, io3, io4, io5, io6 = [[a,0],[b],[c],[d],[e],[]]
        IntCode(code, io1, io2).run()
        IntCode(code, io2, io3).run()
        IntCode(code, io3, io4).run()
        IntCode(code, io4, io5).run()
        IntCode(code, io5, io6).run()
        part1 = max(part1, io6[0])
                        
    part2 = 0
    for a,b,c,d,e in permutations(range(5,10)):
        io1, io2, io3, io4, io5 = [[a,0],[b],[c],[d],[e]]
        computers = [IntCode(code, io1, io2),
        IntCode(code, io2, io3),
        IntCode(code, io3, io4),
        IntCode(code, io4, io5),
        IntCode(code, io5, io1)]
        i = 0
        outputs = []
        while not computers[i].halted:
            computers[i].run()
            i = (i+1)%5
            if i %5 == 0:
                outputs.append(io1[-1])
        part2 = max(part2, outputs[-1])
    return part1, part2
 



run(solve)