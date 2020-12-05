from aoc import *
from hashlib import md5

def solve(inp):
    part1 = solve_(inp)
    part2 = solve_(inp, True)
    return part1, part2

def solve_(inp, stretch=False):
    keys = 0
    def hash(n):
        if len(hash.known) <= n:
            ret = md5((inp + str(n)).encode()).hexdigest()
            if stretch:
                for i in range(2016):
                    ret = md5(ret.encode()).hexdigest()
            hash.known.append(ret)
        return hash.known[n]
    hash.known = []
    def r5(d, h):
        for D in zip(*(h[s:] for s in range(5))):
            if all(d == a for d in D):
                return True
        return False
    i = -1
    while keys < 64:        
        i += 1
        h = hash(i)
        r = ""
        for a, b, c in zip(h, h[1:], h[2:]):
            if a == b and b == c:
                r = a
                #print(i, a+b+c)
                break
        if r and any(r5(r, hash(i+s)) for s in range(1, 1001)):
            #print("match")
            keys += 1
        #print()
    return i

run(solve)