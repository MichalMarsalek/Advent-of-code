include aoc
import stats

day 7:
    var s = sorted ints
    func price(x=0):int = x*(x+1) div 2
    part 1: s.mapIt(abs(it-s[500])).sum # stats doesn't have median???
    part 2: s.mapIt(price(abs(it-s.mean.int))).sum