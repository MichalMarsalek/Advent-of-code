from asm import *

class Asm:
    def __init__(self, code):
        if isinstance(code, Asm):
            self.code = list(code.code)
        if isinstance(code, str):
            code = [x.split() for x in code.splitlines()]
            self.code = [(x, int(y)) for x,y in code]

    def run(self):
        acc = 0
        seen = set()
        i = 0
        while i < len(self.code):
            if i in seen:
                return "loop", acc
            seen.add(i)
            op, arg = self.code[i]
            if op == "acc":
                acc += arg
                i += 1
            elif op == "nop":
                i += 1
            elif op == "jmp":
                i += arg
        return "out", acc
    
    def __setitem__(self, key, item):
        self.code[key] = item

    def __getitem__(self, key):
        return self.code[key]