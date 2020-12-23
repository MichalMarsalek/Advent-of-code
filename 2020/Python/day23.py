from aoc import *
from collections import *

class Cup:
    def __init__(self, val):
        self.val = val
        self.right = None
cups = [Cup(i) for i in range(1000001)]
    
def solve(inp):
    #inp = "389125467"
    cups = [Cup(i) for i in range(1000001)]
    data = [int(x) for x in inp]
    for c, d in zip(data, data[1:] + data[:1]):
        cups[c].right = cups[d]
    curr = cups[data[0]]
    for _ in range(100):
        curr = nxt(cups, curr, min(data), max(data))
    part1 = ""
    curr = cups[1].right
    while curr.val != 1:
        part1 += str(curr.val)
        curr = curr.right
    
    for c, d in zip(data, data[1:] + data[:1]):
        cups[c].right = cups[d]
    cups[data[-1]].right = cups[max(data)+1]
    for i in range(max(data)+1, 1000000):
        cups[i].right = cups[i+1]
    cups[1000000].right = cups[data[0]]    
    curr = cups[data[0]]
    for _ in range(10000000):
        curr = nxt(cups, curr, 1, 1000000)
    part2 = cups[1].right.val * cups[1].right.right.val
    return part1, part2

def nxt(cups, curr, mn, mx):
    a = curr.right
    b = a.right
    c = b.right
    curr.right = c.right
    dest = curr.val
    while dest == curr.val or dest in [a.val, b.val, c.val]:
        dest -= 1
        if dest < mn:
            dest = mx
    dest = cups[dest]
    c.right = dest.right
    dest.right = a
    return curr.right

run(solve)