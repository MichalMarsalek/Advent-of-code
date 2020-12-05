from aoc import *
from hashlib import md5

def solve(inp):
    part1 = ""
    part2 = ['*' for x in range(8)]
    i = 0
    while len(part1) < 8 or '*' in part2:
        hash = md5((inp + str(i)).encode()).hexdigest()
        if hash[:5] == "00000":
            if len(part1) < 8:
                part1 += hash[5]
            if ord(hash[5]) in range(ord('0'), ord('8')):
                pos = int(hash[5])
                if part2[pos] == '*':
                    part2[pos] = hash[6]
        i += 1
    return part1, ''.join(part2)

run(solve)