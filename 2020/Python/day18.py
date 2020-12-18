from aoc import *

class Int:
    def __init__(self, v):
        self.v = v
    
    def __sub__(a,b):
        return Int(a.v*b.v)
    def __add__(a,b):
        return Int(a.v+b.v)
    def __mul__(a,b):
        return Int(a.v+b.v)
    def __int__(self):
        return self.v

def myeval(inp, part):
    for c in "0123456789":
        inp = inp.replace(c, f"Int({c})")
    inp = inp.replace("*", "-")
    inp = inp.replace("+", "+*"[part])
    return int(eval(inp))

def solve(inp):
    data = inp.splitlines()
    part1 = sum(myeval(transform(x, 0)) for x in data)
    part2 = sum(myeval(transform(x, 1)) for x in data)
    return part1, part2


run(solve)