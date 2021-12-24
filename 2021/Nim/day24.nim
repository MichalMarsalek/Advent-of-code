include aoc

day 24:
    var ins: Grid[int]
    for blck in lines.distribute(14):
        var L = blck.mapIt(it.split)
        ins.add [L[4][2], L[5][2], L[15][2]].map parseInt
    
    var ranges: array[14, Slice[int]]
    var stack: seq[int]
    for i,A in ins:
        if A[0] == 1:
            stack.add i
        else:
            var j = stack.pop
            var B = ins[j]
            var diff = B[2]+A[1]
            if diff < 0:
                ranges[j] = 1-diff..9
                ranges[i] = 1..9+diff
            else:
                ranges[j] = 1..9-diff
                ranges[i] = 1+diff..9    
    part 1: ranges.mapIt(it.b).join                    
    part 2: ranges.mapIt(it.a).join    