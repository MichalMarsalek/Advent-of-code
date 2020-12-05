from aoc import *
from math import gcd

def solve(inp):
    pos = intgrid(inp)
    x, y, z = map(list, zip(*pos))
    vx, vy, vz = [[0,0,0,0] for _ in (x,y,z)]
    for i in range(1000):
        x,vx = simulate(x,vx)
        y,vy = simulate(y,vy)
        z,vz = simulate(z,vz)
    part1 = energy((x,y,z),(vx,vy,vz))
    pos = intgrid(inp)
    x, y, z = map(list, zip(*pos))
    part2 = lcm(lcm(period(x),period(y)),period(z))
    return part1, part2

def simulate(pos, vel):
    pos = list(pos)
    vel = list(vel)
    for m in range(4):
        for n in range(4):
            if m == n:
                continue
            if pos[m] < pos[n]:
                vel[m] += 1
                vel[n] -= 1
    for m in range(4):
        pos[m] += vel[m]
    return pos, vel

def en(d, m):
    return sum(abs(d[i][m]) for i in range(3))
    
def energy(pos, vel):
    return sum(en(pos, m)*en(vel, m) for m in range(4))

def lcm(a, b):
    return a*b // gcd(a, b)

def period(p):
    v = [0,0,0,0]
    start = p,v
    for i in ints():
        p, v = simulate(p,v)
        if (p,v) == start:
            return i


run(solve)