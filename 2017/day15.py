from aoc import *

def comp(a, b):
    return (a%2**16) == (b%2**16)
def nexta(a):
    return (a*16807) % 2147483647
def nextb(b):
    return (b*48271) % 2147483647

def solve(inp):
    a, b = [int(x.split()[-1]) for x in inp.splitlines()]
    part1 = 0
    for i in range(40*10**6):
        a = nexta(a)
        b = nextb(b)
        part1 += comp(a, b)
    part2 = 0
    for i in range(5*10**6):
        a = nexta(a)
        while(a%4):
            a = nexta(a)
        b = nextb(b)
        while(b%8):
            b = nextb(b)
        part2 += comp(a, b)    
    return part1, part2
        

run(solve)