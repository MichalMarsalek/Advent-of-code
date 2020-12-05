from aoc import *
from collections import *
from IntCode import *

def solve(inp):
    offset = int(inp[:7])
    inp = [int(x) for x in inp]
    part1 = list(inp)
    for i in range(100):
        part1 = fft(part1)
    part1 = "".join(map(str,part1[:8]))
    offset = 10000*len(inp)-offset
    part2 = list(inp)
    part2 = 10000*part2
    part2 = part2[::-1]
    part2 = part2[:offset]
    for i in range(100):
        part2 = fft_last(part2, offset)
    part2 = part2[::-1]
    part2 = "".join(map(str,part2[:8]))
    return part1, part2

def fft(row):
    res = [0]*len(row)
    for i in range(len(row)):
        pattern = (i+1)*[0]+(i+1)*[1]+(i+1)*[0]+(i+1)*[-1]
        pattern = (len(row)//(i+1)+1)*pattern
        for j in range(len(row)):
            res[i] += row[j] * pattern[j+1]
        if res[i] < 0:
            res[i] *= -1
        res[i] = res[i] % 10
    return res

def fft_last(row,l):
    res = [row[0]]
    for i in range(1,l):
        res.append(0)
        res[i] = (res[i-1]+row[i]) % 10
    return res
    

run(solve)