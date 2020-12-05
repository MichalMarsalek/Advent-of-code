from collections import *

class IntCode:
    def __init__(self, code, inp = None, out = None):
        if inp is None:
            inp = list()
        if out is None:
            out = list()
        if isinstance(code, str):
            code = [int(x) for x in code.split(",")]
        self.code = defaultdict(int)
        for i in range(len(code)):
            self.code[i] = code[i]
        self.inp = inp
        self.out = out
        self.i = 0
        self.halted = False
        self.base = 0
    
    #Input can be string
    def run(self, *inp):
        if inp and isinstance(inp[0], str):
            inp = [ord(x) for x in inp[0]]
        self.inp.extend(inp)
        def pos(i, mode):
            if mode == 1: #Immediate
                return i
            if mode == 0: #Position
                return self.code[i]
            if mode == 2: #Relative
                return self.code[i]+self.base
        code = self.code
        while True:
            i = self.i
            co = code[self.i]
            op = co % 100
            a = (co//100)%10
            b = (co//1000)%10
            c = (co//10000)%10
            d = (co//100000)%10
            if op == 99: #Halt
                self.halted = True
                return self.out
            if op == 1: #Add                
                code[pos(i+3, c)] = code[pos(i+1, a)] + code[pos(i+2,b)]
                self.i+= 4
            if op == 2: #Multiply
                code[pos(i+3, c)] = code[pos(i+1, a)] * code[pos(i+2,b)]
                self.i+=4
            if op == 3: #Input
                if not self.inp:
                    return self.out
                code[pos(i+1, a)] = self.inp.pop(0)
                self.i+=2
            if op == 4: #Output
                self.out.append(code[pos(i+1, a)])
                self.i+= 2
            if op == 5: #Jump if nonzero
                if code[pos(i+1, a)]:
                    self.i= code[pos(i+2, b)]
                else:
                    self.i+= 3
            if op == 6: #Jump if zero
                if not code[pos(i+1, a)]:
                    self.i= code[pos(i+2, b)]
                else:
                    self.i+= 3
            if op == 7: #Less than
                if code[pos(i+1, a)] < code[pos(i+2, b)]:
                    code[pos(i+3, c)] = 1
                else:
                    code[pos(i+3, c)] = 0
                self.i+= 4
            if op == 8: #Equals
                if code[pos(i+1, a)] == code[pos(i+2, b)]:
                    code[pos(i+3, c)] = 1
                else:
                    code[pos(i+3, c)] = 0
                self.i+= 4
            if op == 9: #Adjust base
                self.base += code[pos(i+1, a)]
                self.i += 2
    
    #Returns all available characters from output
    def get_text(self):
        res = ""
        while self.out and 0 < self.out[0] < 256:
            res += chr(self.out.pop(0))
        return res
    
    #Passes multiple lines to VM console input and prints any string output
    def console(self, *text):
        self.run()
        response = self.get_text()
        if response:
            print(response, end="")
        text = "\n".join(text)
        if text:
            text = text.replace("\r\n", "\n").replace("\r", "\n")
            print(">>> " + text)
            self.run(text + "\n")
        else:
            self.run()
        response = self.get_text()
        if response:
            print(response, end="")
        if self.out:
            print(f"There are {len(self.out)} non-ASCII values still left.")
        return response
    
    #Return given number of numbers
    def get_vector(self, l):
        return [self.out.pop(0) for _ in range(l)]
        
    def __setitem__(self, key, item):
        self.code[key] = item

    def __getitem__(self, key):
        return self.code[key]