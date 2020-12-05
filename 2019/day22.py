from aoc import *

def solve(inp):
    maps = parse(inp)
    N = 10007
    a, b = compose(maps, N)
    part1 = (a * 2019 + b) % N
    
    N = 119315717514047
    a, b = compose(maps, N)
    exp = 101741582076661
    a, b = power(a, b, exp, N) #we need to invert this
    x = (b * pow(1-a, -1, N) % N)#ax + b = x ==> (a-1)x = -b
    print(x, ((x - b) * pow(a, -1, N)) % N)
    part2 = ((2020 - b) * pow(a, -1, N)) % N
    return part1, part2

#Each technique is x --> ax + b mod N
def parse(inp):
    maps = []
    for line in inp.splitlines():
        p = line.split()
        if p[1] == "with":
            maps.append((int(p[3]), 0))
        elif p[1] == "into":
            maps.append((-1, -1))
        else:
            maps.append((1, -int(p[1])))
    return maps

#Composes the operations
def compose(maps, N):
    a, b = (1, 0)
    for A, B in maps:
        a = (a * A) % N
        b = (b * A + B) % N
    return a, b

#Binary exponentiation
def power(a, b, exp, N):
    A, B = (1, 0)
    while exp:
        if exp & 1:
            A, B = compose([(A, B), (a,b)], N)
        a, b = compose([(a,b), (a,b)], N)
        exp >>= 1
    return A, B

run(solve)