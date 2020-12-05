from aoc import *

def solve(inp):
	opened = 0
	ingarbage = False
	ignore = False
	part1 = 0
	part2 = 0
	for c in inp:
		if ignore:
			ignore = False
		elif c == '!':
			ignore = True
		elif ingarbage:
			if c == ">":
				ingarbage = False
			else:
				part2 +=1
		elif c == "<":
			ingarbage = True
		elif c == "{":
			opened += 1
		elif c == "}":
			part1 += opened
			opened -= 1
	return part1, part2

run(solve)