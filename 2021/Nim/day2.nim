include aoc

day 2:    
    part 1:
        var x,y = 0
        for L in lines:
            let X = L.ints[0]
            case L[0]
            of 'u': y -= X
            of 'd': y += X
            else: x += X
        return x*y
    part 2:
        var x,y,aim = 0
        for L in lines:
            let X = L.ints[0]
            case L[0]
            of 'u': aim -= X
            of 'd': aim += X
            else: x += X; y += aim*X
        return x*y