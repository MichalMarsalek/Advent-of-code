include aoc

day 17:
    let x0 = ints[0]
    let x1 = ints[1]
    let y0 = ints[2]
    let y1 = ints[3]
    var maxy = 0
    proc goesIn(v: Point, a,b:Point):bool =
        var p: Point
        var v = v
        var mx = 0
        while p.y >= a.y:
            mx = max(mx, p.y)
            p = p + v
            v = (v.x - v.x.sgn, v.y-1)
            if a.x <= p.x and p.x <= b.x and a.y <= p.y and p.y <= b.y:
                maxy = max(maxy, mx)
                return true
    var p2 = 0
    for y in y0..max(abs(y0), abs(y1)):
        for x in sqrt(float(2*x0)).int-1..x1: 
            tot += 1
            if goesIn((x,y),(x0,y0),(x1,y1)):
                p2 += 1
    part 1:
        maxy
    part 2:
        p2
