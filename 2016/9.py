from aoc import *

def solve(inp):
    part1 = decoded_len(inp)
    part2 = decoded_len(inp, True)
    return part1, part2

def decoded_len(inp, recursive=False):
    decoded = 0
    pos = 0
    while pos < len(inp):
        if inp[pos] == "(":
            marker = inp[pos+1:].split(")")[0]
            pos += 2 + len(marker)
            leng, rep = map(int, marker.split("x"))
            decoded += (decoded_len(inp[pos:pos+leng], True) if recursive else leng) * rep
            pos += leng
        else:
            decoded += 1
            pos += 1
    return decoded   

run(solve)