from aoc import *

def solve(inp):    
    return solve_(inp, 272), solve_(inp, 35651584)

def solve_(inp, disk_size):
        while len(inp) < disk_size:
            #print(len(inp) / disk_size)
            inp = dragon(inp)
        chsum = checksum(inp[:disk_size])
        while len(chsum) % 2 == 0:
            chsum = checksum(chsum)
        return chsum
def dragon(t):
    return t + "0" + "".join("0" if x=="1" else "1" for x in t[::-1])

def checksum(t):
    ret = ""
    for i in range(0, len(t), 2):
        ret += "1" if t[i] == t[i+1] else "0"
    return ret

run(solve)