from aoc import *

def solve(inp):
    part1 = ""
    part2 = ""
    x, y = 1, 1
    x2, y2 = 0, 2
    actual = ('','','1','',''), ('','2','3','4',''), ('5','6','7','8','9'),('','A','B','C',''),('','','D','','')
    for line in inp.splitlines():
        for ins in line:
            dx, dy = {'L': (-1, 0), 'U': (0, -1), 'R': (1, 0), 'D': (0, 1)}[ins]
            x = max(0, min(x+dx, 2))
            y = max(0, min(y+dy, 2))
            if dy+y2 in range(5) and dx+x2 in range(5) and actual[dy+y2][dx+x2] != '':
                y2 += dy
                x2 += dx
        part1 += str(y*3 + x + 1)
        part2 += actual[y2][x2]
    return part1, part2

run(solve)