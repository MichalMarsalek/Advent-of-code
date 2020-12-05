from aoc import *

def solve(inp):
    part1 = scramble("abcdefgh", inp)
    part2 = scramble("fbgdceah", inp, True)
    return part1, part2
    
def scramble(text, inp, reverse=False):
    for ins in inp.split("\n")[::-1] if reverse else inp.split("\n"):
        old = text
        ins = ins.split()
        if ins[0] == "swap" and ins[1] == "position":
            i, j = int(ins[2]), int(ins[5])
            i, j = sorted((i, j))
            text = text[:i] + text[j] + text[i+1:j] + text[i] + text[j+1:]
        elif ins[0] == "swap" and ins[1] == "letter":
            a, b = ins[2][0], ins[5][0]
            text = "".join(a if x==b else (b if x==a else x) for x in text)
        elif ins[0] == "rotate":
            if reverse:
                if ins[1] != "based":
                    i = int(ins[2])
                    i = i if ins[1] != "left" else len(text)-i
                    text = text[i:] + text[:i]
                else:
                    x = ins[6][0]
                    for i in range(len(text)):
                        var = text[i:] + text[:i]
                        if scramble(var, "rotate based on position of letter " + x) == text:
                            text = var
                            break
            else:
                if ins[1] == "based":
                    x = ins[6][0]
                    i = text.index(x)
                    i = i + 2 if i >= 4 else i+1
                    i = len(text)-i                
                else:
                    i = int(ins[2])
                    i = i if ins[1] == "left" else len(text)-i
                text = text[i:] + text[:i]
        elif ins[0] == "reverse":
            i, j = int(ins[2]), int(ins[4])
            i, j = sorted((i, j))
            text = text[:i] + text[i:j+1][::-1] + text[j+1:]
        elif ins[0] == "move":
            i, j = int(ins[2]), int(ins[5])
            if reverse:
                i, j = j, i
            x = text[i]
            text = text[:i] + text[i+1:]
            text = text[:j] + x + text[j:]        
    return text

run(solve)