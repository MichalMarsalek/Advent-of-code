from aoc import *

    def solve(inp):
        map = inp.splitlines()
        y = 0
        x = 0
        dx, dy = 0, 1
        part1 = ""
        part2 = 0
        for x in range(len(map[y])):
            if map[y][x] != " ":
                break
        def inbounds(x, y):
            return x in range(len(map[0])) and y in range(len(map))
        while inbounds(x, y) and map[y][x] != " ":
            part2 += 1
            if ord(map[y][x]) in range(ord("A"), ord("Z")+1):
                part1 += map[y][x]
            if inbounds(x+dx, y+dy) and map[y+dy][x+dx] != " ":
                x += dx
                y += dy
                continue
            dx, dy = -dy, dx
            if inbounds(x+dx, y+dy) and map[y+dy][x+dx] != " ":
                x += dx
                y += dy
                continue
            dx, dy = -dx, -dy
            x += dx
            y += dy
        return part1, part2        

run(solve, "day19", True)