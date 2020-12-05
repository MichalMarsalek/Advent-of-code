from aoc import *

def solve(inp):
    lcd = [[False] * 50 for a in range(6)]
    for linee in inp.split("\n"):
        op, *line = linee.split()
        if op == "rect":
            X, Y = map(int, line[0].split("x"))
            for y in range(Y):
                for x in range(X):
                    lcd[y][x] = True
        else:
            dir, which, _, amount = line
            which = int(which[2:])
            amount = int(amount)
            for i in range(amount):
                if dir == "row":
                    lcd[which] = lcd[which][-1:] + lcd[which][:-1]
                else:
                    copy = lcd[-1][which]
                    for y in range(5,0,-1):
                        lcd[y][which] = lcd[y-1][which]
                    lcd[0][which] = copy
    part1 = sum(sum(r) for r in lcd)
    part2 = "\n".join("".join("#" if yo else "." for yo in row) for row in lcd)
    print(part2)
    print()
    return part1, part2


run(solve)