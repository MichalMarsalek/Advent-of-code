from aoc import *

def solve(inp):
    instructions = [Instruction(line) for line in inp.split("\n")]
    outputs = dict()
    bots = dict()
    part1 = None
    while instructions:
        for i in range(len(instructions)):
            ins = instructions[i]
            if ins.gives:
                if ins.frm in bots and len(bots[ins.frm]) == 2:
                    if ins.to1 not in (outputs, bots)[ins.to1bot]:
                        (outputs, bots)[ins.to1bot][ins.to1] = []
                    (outputs, bots)[ins.to1bot][ins.to1].append(min(bots[ins.frm]))
                    if ins.to2 not in (outputs, bots)[ins.to2bot]:
                        (outputs, bots)[ins.to2bot][ins.to2] = []
                    (outputs, bots)[ins.to2bot][ins.to2].append(max(bots[ins.frm]))
                    if set(bots[ins.frm]) == set([17, 61]) and part1 is None:
                        part1 = ins.frm
                    bots[ins.frm] = []
                else:
                    continue
            else:
                if ins.to not in bots:
                    bots[ins.to] = []
                bots[ins.to].append(ins.value)
            del instructions[i]
            break
    print(outputs)
    part2 = outputs[0][0] * outputs[1][0] * outputs[2][0]
    return part1, part2

class Instruction:
    def __init__(self, text):
        self.data = text
        data = text.split()
        if data[0] == "bot":
            self.gives = True
            self.frm = int(data[1])
            self.to1bot = data[5] == "bot"
            self.to1 = int(data[6])
            self.to2bot = data[10] == "bot"
            self.to2 = int(data[11])
        else:
            self.gives = False
            self.value = int(data[1])
            self.to = int(data[5])
    
    def __repr__(self):
        return self.data


run(solve)