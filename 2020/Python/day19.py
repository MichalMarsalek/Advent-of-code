from aoc import *

def solve_part(inp):
    inp = inp.split("\n\n")
    data = [x.split(": ") for x in  inp[0].splitlines()]
    rules = {}
    for k,v in data:
        if '"' in v:
            rules[int(k)] = v.replace('"', "")
        else:
            rules[int(k)] = [[int(y) for y in x.split()] for x in v.split(" | ")]
    def check_rule(text, r, depth):
        #print("   "*depth+ "text:", text, "r:", r)
        if len(text) == 0:
            return []
        if isinstance(rules[r], str):
            if text[0] == rules[r]:
                return [1]
            else:
                return []
        length0 = []
        for disj in rules[r]:
            length = [0]
            for conj in disj:
                length2 = []
                #print("   "*depth+ "text:", text, "r:", r, "disj:", disj, "conj:", conj, "length:", length)
                for l in length:
                    for c in check_rule(text[l:], conj, depth+1):                        
                        length2.append(l+c)
                length = length2
                #print("   "*depth+"length:", length)
            length0.extend(length)         
        return length0
        
    queries = inp[1].splitlines()
    return sum(len(q) in check_rule(q,0,0) for q in queries)

def solve(inp):
    part1 = solve_part(inp)
    part2 = solve_part(inp.replace("8: 42", "8: 42 | 42 8").replace("11: 42 31", "11: 42 31 | 42 11 31"))
    return part1, part2

run(solve)