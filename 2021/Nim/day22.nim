include aoc
import rectangles3

day 22:
    var points = initRectangleUnion[3]()
    for line in lines:
        var (x0,x1,y0,y1,z0,z1) = ints6(line)
        let startComplexity = points.rectangles.len
        if "on" in line:
            points += [x0,y0,z0]^>[x1,y1,z1]
        else:
            points -= [x0,y0,z0]^>[x1,y1,z1]
        if points.rectangles.len < startComplexity:
            dump (startComplexity, points.rectangles.len)
    
    echo (points.rectangles.len, 115032)
    part 1: card points * [-50,-50,-50]^>[50,50,50]
    part 2: card points