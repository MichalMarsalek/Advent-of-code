from aoc import *

def rotate(part, r=1):
    if r == 0:
        return part
    return rotate(list(zip(*part[::-1])), r-1)

def match(part, rule):
    return all(tuple(rule[i]) == tuple(part[i]) for i in range(len(part)))

def solve(inp):
    def nxt(im):
        res = list()
        if len(im) % 2 == 0:
            res = [[None for _ in range(len(im)//2*3)] for _ in range(len(im)//2*3)]
            sh = 2
        else:
            res = [[None for _ in range(len(im)//3*4)] for _ in range(len(im)//3*4)]
            sh = 3
        r = range(len(im) // sh)
        rules = rules2 if sh == 2 else rules3
        for y in r:
            for x in r:
                part = tuple(tuple(im[sy][sx] for sx in range(x*sh, x*sh+sh)) for sy in range(y*sh, y*sh+sh))
                #print(im, x, y, part)
                print(part)
                rule_o = rules[part]
                for sy in range(sh+1):
                    for sx in range(sh+1):
                        res[y*(sh+1) + sy][x*(sh+1) + sx] = rule_o[sy][sx]
                        break
        return res
    img = [".#.", "..#", "###"]
    rules = [[[list(z) for z in y.split("/")] for y in x.split(" => ")] for x in inp.splitlines()]
    rules = [(rotate(rule_i[::o], r), rule_o) for rule_i, rule_o in rules for o in (-1, 1) for r in range(4)]
    rules2 = {tuple(map(tuple, ri)): ro for ri, ro in rules if len(ri) == 2}
    rules3 = {tuple(map(tuple, ri)): ro for ri, ro in rules if len(ri) == 3}
    #print(rules)
    for _ in range(5):
        #print(img)
        #print("----------------------------------")
        img = nxt(img)
    part1 = sum(sum(c == "#" for c in line) for line in img)
    
    part2 = None
    return part1, part2
        

run(solve)