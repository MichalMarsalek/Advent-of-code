from aoc import *
from collections import deque

def solve(inp):
	cons = [[int(y) for y in l.split(" <-> ")[1].split(", ")] for l in inp.splitlines()]
	connected = set()
	part2 = 0
	rest = list(range(2000))
	for s in range(2000):
		if s in rest:
			q = deque([s])
			while q:
				dq = q.pop()
				for n in cons[dq]:
					if n not in connected:
						connected.add(n)
						q.append(n)
						rest.remove(n)
			part2 += 1
		if s == 0:
			part1 = len(connected)
	
	return part1, part2
        

run(solve)