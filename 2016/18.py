from aoc import *

def solve(inp):
    return solve_(inp, 40), solve_(inp, 400000)

def solve_(inp, height):    
    room = [[x == "." for x in inp]]
    for i in range(height-1):
        room.append([not safe(room[i], x) for x in range(100)])
    return sum(sum(x) for x in room)

def safe(r, x):
    val = lambda p: (p not in range(100)) or r[p]
    return val(x-1) != val(x+1)

run(solve)