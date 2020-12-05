import os
import sys
import requests
from time import perf_counter
import re
import matplotlib.pyplot as plt     

directions8 = (-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)
directions4 = (0, -1), (1, 0), (0, 1), (-1, 0)
def neigbours8(x, y):
    for dx, dy in directions8:
        yield x+dx, y+dy
def neigbours4(x, y):
    for dx, dy in directions4:
        yield x+dx, y+dy

def count(x):
    return len(list(x))

def plot_complex(points):
    X = [x.real for x in points]
    Y = [x.imag for x in points]
    plt.scatter(X,Y)
    plt.axis('equal')
    plt.show()

def plot_grid(grid):
    for v in grid.values():
        X = [x.real for x in grid.keys() if grid[x] == v]
        Y = [x.imag for x in grid.keys() if grid[x] == v]
        plt.scatter(X,Y)    
    plt.axis('equal')
    plt.show()

def manhattan(a, b=0):
    a -= b
    return int(abs(a.real) + abs(a.imag))


def run(fnc, problem=None, dontStrip=False):
    if problem is None:
        problem = os.path.basename(sys.argv[0]).replace(".py", "").replace(".coco", "")
    else:
        problem = str(problem)
    if not os.path.isfile(problem + ".in") and problem in map(str, range(1, 26)):
        cookies = {"session": "53616c7465645f5f0e7daebef2720671616e2dfbccc65c83b25d5a3cfb2fea7e0423c6488fd02ac2690ea4a6bc50e2bd"}
        req = requests.get("http://adventofcode.com/2017/day/" + problem.replace("day", "") + "/input", cookies=cookies)
        with open(problem + ".in", mode='wb') as f:
            f.write(req.content)
        print("Downloading input.")
    inp = None
    if os.path.isfile(problem + ".in"):
        with open(problem + ".in") as f:
            inp = f.read()
    start = perf_counter()
    res = fnc(inp if dontStrip else inp.strip())
    tot_time = perf_counter()-start
    ans = "Result: %s\nTime: %.8f s" %(res, tot_time)
    print(ans)
    with open(problem + ".out", mode="w") as f:
        f.write(ans)
        
def intgrid(inp):
    return [introw(x) for x in inp.splitlines()]

def introw(inp):
    return [int(x) for x in re.findall(r'[-\d]+', inp)]

def intcolumn(inp):
    return [x[0] for x in intgrid(inp)]
    
def multisplit(text, dels):
    for c in dels:
        text = text.replace(c, " ")
    return text.split()

def ints(i = 1, step = 1):
    while True:
        yield i
        i += step