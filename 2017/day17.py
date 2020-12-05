from aoc import *

def solve(inp):
    inp = int(inp)
    b = [0]
    p = 0
    for i in range(1, 2018):
        p = (p+inp) % (i) + 1
        b.insert(p, i)
    part1 = b[(p+1)%2018]    
    for i in range(1, 50*10**6+1):
        p = (p+inp) % (i) + 1
        if p == 1:
            part2 = i
    return part1, part2
        

run(solve)