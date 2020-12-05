from aoc import *
from hashlib import md5

def solve(inp):    
    nxt = [(0, 0, "")]
    sols = []
    while nxt:
        curr = nxt
        nxt = []
        for x, y, path in curr:
            dirs_ = md5((inp + path).encode()).hexdigest()[:4]
            dirs = zip(((0,-1), (0,1), (-1, 0), (1, 0)), ('U', 'D', 'L', 'R'), (x in ("bcdef") for x in dirs_))
            for dir, code, free in dirs:
                nx, ny = x+dir[0], y+dir[1]
                if nx in range(4) and ny in range(4) and free:
                    if (nx, ny) == (3, 3):
                        sols.append(path+code)
                    else:
                        nxt.append((nx, ny, path+code))
    return sols[0], len(sols[-1])

run(solve)