from aoc import *
from collections import *

def solve(inp):
    conds = inp.splitlines()
    conds1 = [[(cond.split()[1], cond.split()[7])for cond in conds]]
    conds2 = [list(conds1)[0]]
    conds0 = [list(conds1)[0]]
    order = []
    alpha1 = [sorted(set([x[1] for x in conds1[0]]) | set([x[0] for x in conds1[0]]))]
    alpha2 = [list(alpha1)[0]]
    def getnext(alpha, conds):
        try:
            a = next(b for b in alpha[0] if b not in [x[1] for x in conds[0]])
            conds[0] = [c for c in conds[0] if c[0] != a]
            alpha[0] = [x for x in alpha[0] if x != a]
            return a
        except:
            return None
    while alpha1[0]:
        a = getnext(alpha1, conds1)
        order.append(a)
    part1 = "".join(order)
    workers = 5*[0]
    sec = -1
    while alpha2[0] or any(w != 0 for w in workers):
        sec += 1
        conds2[0] = [c for c in conds2[0] if c[0] != sec]
        workers = [max(0, w-1) for w in workers]
        if alpha2[0]:
            for i in range(5):
                if workers[i] == 0:
                    a = getnext(alpha2, conds2)
                    if a is not None:
                        time = 61+ord(a)-ord("A")
                        for aa, act in conds0[0]:
                            if aa == a:
                                conds2[0].append((sec + time, act))
                        workers[i] = time      
    part2 = sec
    return part1, part2

run(solve)