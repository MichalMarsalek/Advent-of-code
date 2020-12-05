from aoc import *

def solve(inp):
	
	fire = {int(d): int(r) for d, r in (l.split(": ") for l in inp.splitlines())}
	maxd = max(fire.keys())
	def severity(d):
		s = 0
		for t in range(maxd+1):
			if t in fire:
				if (t+d) % (2*fire[t]-2) == 0:
					s += max(0.1, (t)*fire[t])
				
		return s
	part1 = int(severity(0))
	for d in range(10**8):
		if severity(d) == 0:
			return part1, d



run(solve)