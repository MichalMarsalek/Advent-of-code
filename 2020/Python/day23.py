from aoc import *
    
def solve(inp):
    right = 1000001*[None]
    data = [int(x) for x in inp]
    for c, d in zip(data, data[1:] + data[:1]):
        right[c] = d
    curr = data[0]
    for _ in range(100):
        curr = nxt(right, curr, min(data), max(data))
    part1 = ""
    curr = right[1]
    while curr != 1:
        part1 += str(curr)
        curr = right[curr]
    
    for c, d in zip(data, data[1:]):
        right[c] = d
    right[data[-1]] = max(data)+1
    for i in range(max(data)+1, 1000000):
        right[i] = i+1
    right[1000000] = data[0]  
    curr = data[0]
    for _ in range(10000000):
        curr = nxt(right, curr, 1, 1000000)
    part2 = right[1] * right[right[1]]
    return part1, part2

def nxt(right, curr, mn, mx):
    a = right[curr]
    b = right[a]
    c = right[b]
    right[curr] = right[c]
    dest = curr
    while dest == curr or dest in (a, b, c):
        dest -= 1
        if dest < mn:
            dest = mx
    right[c] = right[dest]
    right[dest] = a
    return right[curr]

run(solve)