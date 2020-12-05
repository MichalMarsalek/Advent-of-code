from aoc import *

def solve(inp):
    discs = [Disc(line) for line in inp.splitlines()]
    part1 = solve_(discs)
    part2 = solve_(discs + [Disc("Disc #7 has 11 positions; at time=0, it is at position 0.")])
    return part1, part2

def solve_(discs):
    for t in ints(0):
        if all(disc.at(t+i) == 0 for i, disc in enumerate(discs, start=1)):
            return t
    
class Disc:
    def __init__(self, text):
        _,id,_,size,_,_,_,_,_,_,_,pos = text.split()
        self.id = int(id[1:])
        self.size = int(size)
        self.pos = int(pos[:-1])
    
    def at(self, t):
        return (self.pos + t) % self.size

run(solve)