from aoc import *
from collections import Counter

def solve(inp):
    part1 = ""
    part2 = ""
    words = inp.splitlines()
    for i in range(len(words[0])):
        counter = Counter(word[i] for word in words)
        part1 += counter.most_common(1)[0][0]
        part2 += counter.most_common()[-1][0]    
    return part1, part2

run(solve)