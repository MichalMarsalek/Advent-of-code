from aoc import *
from collections import Counter

def solve(inp):
    part1 = sum(sid(room) for room in inp.splitlines() if real(room))
    for room in inp.split("\n"):
        if real(room) and "northpole object" in decode(room):
            part2 = sid(room)
    return part1, part2

def decode(room):
    return "".join(' ' if x == '-' else chr(ord('a') + (ord(x) - ord('a') + sid(room)) % 26) for x in room[:-11])

def sid(room):
    return int(room[-10:-7])

def real(room):
    counter = Counter()
    check_sum = room[-6:-1]
    for char in room[:-11]:
        if char == '-': continue
        counter[char] = counter[char] + 100
    for key in counter:
        counter[key] -= ord(key)
    suma = "".join(x[0] for x in counter.most_common(5))
    return suma == check_sum
    

run(solve)