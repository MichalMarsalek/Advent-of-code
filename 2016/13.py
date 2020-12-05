from aoc import *

def solve(inp):
    goal = 31, 39
    lab = gen_lab(50, 50, int(inp))
    part1 = path_len(lab, (1, 1), goal)
    part2 = sum(lab[y][x]==0 and path_len(lab, (1,1), (x, y)) <= 50 for x in range(50) for y in range(50)) #wtf is this man, optimize this
    return part1, part2

def path_len(lab, a, b):
    lab = [[c for c in r] for r in lab]
    ax, ay = a
    bx, by = b
    next_level = [(ax, ay)]
    dist = 0
    while next_level:
        curr_level = next_level
        next_level = []
        for cell in curr_level:
            cx, cy = cell
            if cell == b:
                return dist
            lab[cy][cx] = 1
            for dx, dy in (-1, 0), (1, 0), (0, -1), (0, 1):
                if cy+dy in range(len(lab)) and cx+dx in range(len(lab[0])) and lab[cy+dy][cx+dx] == 0:
                    next_level.append((cx+dx, cy+dy))
        dist += 1
        
    
def gen_lab(width, height, seed):
    wall = lambda x, y: (sum(l == "1" for l in str(bin(x*x + 3*x + 2*x*y + y + y*y + seed))[2:]) % 2)
    return [[wall(x, y) for x in range(width)] for y in range(height)]

run(solve)