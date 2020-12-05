from aoc import *
from collections import *
from itertools import permutations
from IntCode import *       
import matplotlib.pyplot as plt     

def solve(code):
    grid = defaultdict(int)
    painted = set()
    pos = 0 + 0j
    dir = 1j    
    pc = IntCode(code)
    while not pc.halted:        
        pc.run(grid[pos])
        grid[pos] = pc.out.pop(0)
        painted.add(pos)
        dir *= -1j if pc.out.pop(0) else 1j
        pos += dir
    part1 = len(painted)
    
    grid = defaultdict(int)
    pos = 0 + 0j
    dir = 1j    
    grid[pos] = 1
    pc = IntCode(code)
    while not pc.halted:
        pc.run(grid[pos])
        grid[pos] = pc.out.pop(0)
        dir *= -1j if pc.out.pop(0) else 1j
        pos += dir
    part2 = "See plot"
    plot_grid(grid)
    return part1, part2
    
        
        
    
 



run(solve)