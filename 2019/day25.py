from aoc import *
from collections import *
from itertools import product
from IntCode import * 

def solve(code):
    pc = IntCode(code)
    start = ["north", "east", "east", "east", "take whirled peas", "west", "west", "west", "take mutex", "south", "west", "north", "take loom", "south", "take space law space brochure", "south", "take hologram", "west", "take manifold", "east", "north", "east", "south", "take cake", "west", "south", "take easter egg", "south"]
    for s in start:
        pc.console(s)
    items = ["whirled peas", "hologram", "cake", "space law brochure", "loom", "mutex", "manifold", "easter egg"]
    items = [x[5:] for x in start if x[:4] == "take"]
    state = (1,1,1,1,1,1,1,1)
    print(30*"#")
    print("Bruteforce")
    print(30*"#")
    for comb in product((1,0), repeat=8):
        for i in range(8):
            if state[i] and not comb[i]:
                pc.run("drop " + items[i] + "\n")
            elif not state[i] and comb[i]:
                pc.run("take " + items[i] + "\n")
        pc.run("south\n")
        out = pc.get_text()
        if "Security Checkpoint" not in out:
            print(out)
            part1 = 262848
            break
        state = comb
        #input()
            
    #while not pc.halted:
    #    pc.console(input())
    
            
    part2 = None
    return part1, part2      

run(solve)