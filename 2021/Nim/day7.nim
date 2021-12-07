include aoc

day 7:
    var
     s = sorted ints
     median = s[500]
     mean   = s.sum div s.len
    func price(x=0):int = x*(x+1) div 2
    part 1: s.mapIt(abs(it-median)).sum
    part 2: min(
                s.mapIt(price(abs(it-mean))).sum,
                s.mapIt(price(abs(it-mean-1))).sum
            )