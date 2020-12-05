from aoc import *
import cmath
from math import sqrt, floor

class NumberSpiral:
    def __init__(self, radius, populate=True):
        self.radius = radius
        self.diam = radius*2+1
        self.grid = [[None]* self.diam for _ in range(self.diam)]
        if populate:
            self.fill()
    
    def next(self, z):
        x, y = z.real, z.imag
        r = max(abs(x), abs(y))
        if y == -r:
            return z + 1
        if x == -r:
            return z - 1j
        if y == r:
            return z - 1
        return z + 1j
    
    def __getitem__(self, key):
        x, y = int(key.real), int(key.imag)
        return self.grid[y + self.radius][x + self.radius]
    
    def __setitem__(self, key, value):
        x, y = int(key.real), int(key.imag)
        self.grid[y + self.radius][x + self.radius] = value
    
    def fill(self):
        i = 0
        for n in range(self.diam**2):
            self[i] = n+1
            i = self.next(i)
    
    def __str__(self):
        maxlen = max(map(lambda x: len(str(x)), sum(self.grid, [])))
        return "\n".join("[" + " ".join(str(n).rjust(maxlen) for n in row) + "]" for row in reversed(self.grid))
    
    @staticmethod
    def at_coordinates(z):
        x, y = int(z.real), int(z.imag)
        r = max(abs(x), abs(y))
        if y == -r:
            return (2*r+1)**2 - r + x
        if x == -r:
            return (2*r+1)**2 - 3*r - y
        if y == r:
            return (2*r+1)**2 - 5*r - x
        return (2*r+1)**2 - 7*r + y
    
    @staticmethod
    def coordinates_of(n):
        edge = floor(sqrt(4*n-3))
        shift = n - 1 - edge**2//4
        res = (shift - (edge+1)//4) * 1j**(edge-1) + (edge+2)//4 * 1j**(edge-2)
        return complex(round(res.real), round(res.imag))

def solve(inp):
    coord = NumberSpiral.coordinates_of(int(inp))
    part1 = int(abs(coord.real) + abs(coord.imag))
    
    
    spiral = NumberSpiral(5, False)
    i = 1
    spiral[0] = 1
    dirs = [n*1j**p for n in [1, 1 + 1j] for p in [0, 1, 2, 3]]
    while abs(i) <= abs(4 + 4j):
        spiral[i] = sum(spiral[i + n] for n in dirs if spiral[i + n] is not None)
        i = spiral.next(i)
    print(str(spiral))
    
    spiral = NumberSpiral(4000, False)
    i = 1
    spiral[0] = 1
    dirs = [n*1j**p for n in [1, 1 + 1j] for p in [0, 1, 2, 3]]
    while True:
        spiral[i] = sum(spiral[i + n] for n in dirs if spiral[i + n] is not None)
        if spiral[i] > int(inp):
            return part1, spiral[i]
        i = spiral.next(i)
    return part1, part2

run(solve)