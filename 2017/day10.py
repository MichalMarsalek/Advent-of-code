from aoc import *
S = 256
from functools import *
    
def solve(inp):
    ls = [int(x) for x in inp.split(",")]
    res, _, _ = hash(ls)
    part1 = res[0]*res[1]
    ls = [ord(x) for x in inp] + [17, 31, 73, 47, 23]
    curr=0
    skip=0
    res = list(range(256))
    for i in range(64):
        res, curr, skip = hash(ls, res, curr, skip)
    res = [condense(res[i*16:i*16+16]) for i in range(16)]
    part2 = "".join(hex(n)[2:] for n in res)

    return part1, part2

def hash(lens, res=None, curr=0, skip=0):
    lens = [ord(x) for x in lens] + [17, 31, 73, 47, 23]
    nums = [x for x in range(0,256)]
    pos = 0
    skip = 0
    for _ in range(64):
        for l in lens:
            to_reverse = []
            for x in range(l):
                n = (pos + x) % 256
                to_reverse.append(nums[n])
            to_reverse.reverse()
            for x in range(l):
                n = (pos + x) % 256
                nums[n] = to_reverse[x]
            pos += l + skip
            pos = pos % 256
            skip += 1
    dense = []
    for x in range(0,16):
        subslice = nums[16*x:16*x+16]
        dense.append('%02x'%reduce((lambda x,y: x ^ y),subslice))
    #print(dense)
    return ''.join(dense)

if __name__ == "__main__":
    run(solve)