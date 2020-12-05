from aoc import *
from collections import *

def solve(inp):
    print(inp)
    #inp = intgrid(inp)
    l = min(range(len(inp)//25//6), key=lambda l: sum(inp[25*6*l+x] == "0" for x in range(25*6)))
    n1 = sum(inp[25*6*l+x] == "1" for x in range(25*6))
    n2 = sum(inp[25*6*l+x] == "2" for x in range(25*6))
    part1 = n1*n2
    part2 = 0
    image = [25*["."] for i in range(6)]
    for l in range(len(inp)//25//6):
        for x in range(25):
            for y in range(6):
                if image[y][x] == ".":
                    image[y][x] = ["-","#","."][int(inp[25*6*l+y*25+x])]
    for i in range(6):
        print("".join(image[i]))
    return part1, part2


run(solve)