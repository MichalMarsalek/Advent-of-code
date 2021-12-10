include aoc

day 10:
    let brackets = {'(':')','[':']','{':'}','<':'>'}.toTable
    let scores1 = {')':3,']':57,'}':1197,'>':25137}.toTable
    let scores2 = {')':1,']':2,'}':3,'>':4}.toTable
    
    proc score(text:string, part:range[1..2]):int =
        var stack = ""
        for e in text:
            if brackets.hasKey e:
                stack = brackets[e] & stack
            else:
                if stack[0] == e:
                    stack = stack[1..^1]
                else:
                    if part == 1: return scores1[e]
        if part == 1: return 0
        for b in stack:
            result = result*5 + scores2[b]
    
    part 1: lines.mapIt(it.score 1).sum
    part 2: lines.filterIt(0 == it.score 1).mapIt(it.score 2).median