from aoc import *

def sim(x):
    px, py, pz, vx, vy, vz, ax, ay, az = x
    vx += ax
    vy += ay
    vz += az
    px += vx
    py += vy
    pz += vz
    return px, py, pz, vx, vy, vz, ax, ay, az

def collisions(p):    
    i = 0
    while i < len(p):
        removed = False
        nt = [x for x in p[i+1:] if x[:3] != p[i][:3]]
        if len(nt) == len(p[i+1:]):
            i += 1
        else:
            p = p[:i] + nt
    return p

def future(p):
    px, py, pz, vx, vy, vz, ax, ay, az = p
    def f(p, v, a, t=1000000000000000000000000000000):
        return a*t*t/2 + v*t + p
    x, y, z = f(px, vx, ax), f(py, vy, ay), f(pz, vz, az)
    return abs(x)+abs(x)+abs(z)

def solve(inp):
    lines = inp.replace("p=<", "").replace(">", "").replace(" v=<", "").replace(" a=<", "").replace(">", "").splitlines()
    p = [[int(x) for x in line.split(",")] for line in lines]
    part1 = min(range(len(p)), key=lambda i: future(p[i]))
    return part1
    for _ in range(10**3):
        p = list(map(sim, p))
        p = collisions(p)
    part2 = len(p)
    return part1, part2
        

run(solve)