include aoc

day 2:
    var x,y,aim = 0
    for L in lines:
        let X = L.ints[0]
        case L[0]
        of 'u': aim -= X
        of 'd': aim += X
        else: x += X; y += aim*X
    part 1: x*aim
    part 2: x*y