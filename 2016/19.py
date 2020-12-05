from aoc import *
from collections import deque 

def solve(inp):
    #inp = 5
    return solve1(int(inp)), solve2(int(inp))

def solve1(inp):
    elves = list(range(1, 1+inp))
    while len(elves) > 1:
        elves = elves[2*(len(elves)%2)::2]
    return elves[0]

def solve2(inp):
    elves = list(range(1, 1+inp))
    while len(elves) > 1:
        del elves[len(elves)//2]
        elves = elves[1:] + elves[0:1]
    return elves[0]

def solve3(inp):
    elves = list(range(1, 1+inp))
    while(len(elves)) > 1000:
        l = len(elves)
        elves = elves[l//3:l//2] + elves[l//2+2::3] + elves[:2*l//3]
    while len(elves) > 1:
        del elves[len(elves)//2]
        elves = elves[1:] + elves[0:1]
    return elves[0]
    
            

run(solve)