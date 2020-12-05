from aoc import *
from collections import *
from math import gcd, atan2

def solve(inp):
    mapa = inp.splitlines()
    h = len(mapa)
    w = len(mapa[0])
    ast = [(x,y) for x in range(w) for y in range(h) if mapa[y][x] in "X#"]
    x, y = max(ast, key=lambda p: visible(mapa, ast, *p))
    part1 = visible(mapa, ast, x, y)-1
    ast.sort(key=lambda p: view(mapa, x, y, *p))
    part2 = ast[200]
    part2 = 100*part2[0] + part2[1]
    return part1, part2

#Given a map, a position of an observer and a position of other asteroid,
#calculate the angle and how many asteroids are in between
def view(mapa, ox, oy, ax, ay): 
    if (ox,oy)==(ax,ay):
        return (0,-100)
    dx = ax-ox
    dy = ay-oy
    g = gcd(dx, dy)
    angle = -atan2(dx, dy)
    dx //= g
    dy //= g
    blocked_by = sum(mapa[oy + dy*i][ox + dx*i] == "#" for i in range(1,g))
    return blocked_by, angle

#Given a map, list of asteroids and position of an observer,
#calculate how many other asteroids he can see
def visible(mapa, ast, ox, oy):
    return sum(view(mapa, ox, oy, ax, ay)[0] == 0 for ax, ay in ast)


run(solve)