include aoc
import stats

day 7:
    var s = sorted ints
    proc price(x=0):int = x*(x+1) div 2
    part 1:
        ints.mapIt(abs(it-s[499])).sum # stats doesn't have median???
    part 2:
        ints.mapIt(price(abs(it-s.mean.int))).sum