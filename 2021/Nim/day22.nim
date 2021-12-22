include aoc
import rectangles

day 22:
    var points = initRectangleUnion[3]()
    for line in lines:
        var (x0,x1,y0,y1,z0,z1) = ints6(line)
        if "on" in line:
            points = points + [x0,y0,z0]^>[x1,y1,z1]
        else:
            points = points - [x0,y0,z0]^>[x1,y1,z1]
    
    echo points.rectangles.len
    part 1: card points * [-50,-50,-50]^>[50,50,50]
    part 2: card points