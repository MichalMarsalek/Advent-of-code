from aoc import *

r0 = list("abcdefghijklmnop")    
def solve(inp):
    order = list(range(16))
    mapping = list(order)
    for move in inp.split(","):
        if move[0] == "s":
            c = int(move[1:])
            order = order[-c:]+order[:-c]
        elif move[0] == "x":
            a, b = [int(x) for x in move[1:].split("/")]
            order[a], order[b] = order[b], order[a]
        else:
            a, b = move[1:].split("/")
            a, b = ord(a)-ord("a"), ord(b)-ord("a")
            ia, ib = mapping.index(a), mapping.index(b)
            mapping[ia], mapping[ib] = b, a
    part1 = "".join(r0[mapping[order[i]]] for i in range(16))
    order = iterate(order, 10**9)
    mapping = iterate(mapping, 10**9)
    part2 = "".join(r0[mapping[order[i]]] for i in range(16))
    return part1, part2

def iterate(perm, c):
    r = list(range(16))
    res = list(range(16))
    while r:
        loop = [r.pop()]
        while perm[loop[-1]] not in loop:
            r.remove(perm[loop[-1]])     
            loop.append(perm[loop[-1]])
        rep = 10**9 % len(loop)
        for i in range(16):
            if i in loop:
                res[i] = loop[(loop.index(i)+rep)%len(loop)]
    return res

run(solve)