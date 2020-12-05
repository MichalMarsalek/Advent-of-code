from aoc import *
from collections import *

class Process:
    def __init__(self, code, registers, input, output, special=None):
        self.instructions = [line.split(" ") + ([""] if line.count(" ") < 2 else []) for line in code.splitlines()]
        self.registers = registers
        self.input = input
        self.output = output
        self.running = True
        self.i = 0
        self.special = special
        self.result = None
    
    def value(self, n):
        try:
            return int(n)
        except:
            return self.registers[n]
    
    def next(self):
        try:
            self.running = True
            self.cmd, self.x, self.y = cmd, x, y = self.instructions[self.i]
            if self.special:
                self.special(self)
            if cmd == "snd":
                self.output.append(self.value(x))
            elif cmd == "rcv":
                if self.input:
                    self.registers[x] = self.input.popleft()
            elif cmd == "set":
                self.registers[x] = self.value(y)
            elif cmd == "add":
                self.registers[x] += self.value(y)
            elif cmd == "mul":
                self.registers[x] *= self.value(y)
            elif cmd == "mod":
                self.registers[x] %= self.value(y)
            elif cmd == "jgz":
                if self.value(x) > 0:
                    self.i += self.value(y)-1
            self.i += 1
        except IndexError:
            self.running = False        

def solve(inp):
    def special1(proc):
        if proc.cmd == "rcv" and proc.value(proc.x) != 0 and proc.result is None:
            proc.result = proc.output.pop()
    def special2(proc):
        print(proc.i, proc.cmd)
        if proc.cmd == "snd":
            proc.result = 1 if proc.result is None else proc.result + 1
        elif proc.cmd == "rcv" and not proc.input:
            proc.i -= 1 
            proc.running = False
    p = Process(inp, defaultdict(int), deque(), deque(), special1)
    while p.result is None:
        p.next()
    q1 = deque()
    q2 = deque()
    d = defaultdict(int)
    d["p"] = 1
    p0 = Process(inp, defaultdict(int), q1, q2, special2)
    p1 = Process(inp, d, q2, q1)
    while p0.running or p1.running:
        p0.next()
        p1.next()
    return p.result, p0.result
            
run(solve, "day18")