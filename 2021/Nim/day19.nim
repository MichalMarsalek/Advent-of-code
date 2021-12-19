include aoc

day 19:
    func rotated(p,perm,signs:Point3):Point3 =
        var r: Point3
        if perm[0] == 0: r[0] = p[0]
        if perm[0] == 1: r[0] = p[1]
        if perm[0] == 2: r[0] = p[2]
        if perm[1] == 0: r[1] = p[0]
        if perm[1] == 1: r[1] = p[1]
        if perm[1] == 2: r[1] = p[2]
        if perm[2] == 0: r[2] = p[0]
        if perm[2] == 1: r[2] = p[1]
        if perm[2] == 2: r[2] = p[2]
        return (signs.x*r.x,signs.y*r.y,signs.z*r.z)
    var rotations: seq[(Point3,Point3)]
    for sx in [-1,1]:
        for sy in [-1,1]:
            for sz in [-1,1]:
                for perm in [(0,1,2),(0,2,1),(1,0,2),(1,2,0),(2,0,1),(2,1,0)]:
                    rotations.add (perm, (sx,sy,sz))
    
    proc match(s1,s2:seq[Point3]):(int, Point3, Point3, Point3) =
        var overlaps: CountTable[(Point3, Point3, Point3)]
        for p in s2:
            for (perm, signs) in rotations:
                let rp = p.rotated(perm, signs)
                for p0 in s1:
                    overlaps.inc (perm, signs, rp-p0)
        let lrg = overlaps.largest
        return (lrg.val, lrg.key[0], lrg.key[1], lrg.key[2])
    
    func aligned(s1:seq[Point3],perm,signs,shift:Point3):seq[Point3] =
        for p in s1:
            let rp = p.rotated(perm,signs)
            result.add(rp-shift)
    
    var scanners = input.split("\n\n").map(B => B.splitLines[1..^1].map ints3)

    var placed = [0].toHashSet
    var notPlaced =(1..<scanners.len).toSeq.toHashSet
    var shifts: seq[Point3]
    while notPlaced.card > 0:
        var j,i = -1
        var s = -1
        var perm, signs, shift: Point3
        block find:
            for jj in notPlaced:
                for ii in placed:
                    (s, perm, signs, shift) = match(scanners[ii],scanners[jj])
                    if s >= 12:
                        j = jj
                        i = ii
                        break find
        
        scanners[j] = scanners[j].aligned(perm,signs,shift)
        shifts.add shift
        placed.incl j
        notPlaced.excl j
    
    var beacons: HashSet[Point3]
    for s in scanners:
        for p in s:
            beacons.incl p    
    
    part 1:
        beacons.card
    part 2,int:
        for i,s1 in shifts:
            for s2 in shifts[0..<i]:
                result = max(result, norm1(s1-s2))