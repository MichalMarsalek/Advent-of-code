include aoc

day 9:
    var data  = lines.map(l => l.mapIt(parseInt($it)))
    var areas = data.continuousAreas((a,b) => (a == 9) == (b == 9))
    areas = areas.filterIt(data[it.toSeq[0]] < 9).sortedByIt it.card
    
    part 1: areas.mapIt(it.map(x => data[x]+1).toSeq.min).sum                    
    part 2: prod areas[^3..^1].map card