import sequtils, sets

type Point*[N] = array[N,int]
type Rectangle*[N] = tuple[low,high:Point[N]]
type RectangleUnion*[N] = object
    rectangles*: seq[Rectangle[N]]


func `$`[N](r: Rectangle[N]): string =
    $r.low & " ^> " & $r.high
func `$`*[N](r: RectangleUnion[N]): string =
    r.rectangles.join(" + ")

proc initRectangleUnion*[N: static[int]](): RectangleUnion[range[0..N-1]] =
    discard

func `[]`[N](r: Rectangle[N], i:int): (int,int) =
    (r.low[i], r.high[i])

func nonzero[N](r: Rectangle[N]): bool =
    let n = N.high+1
    for i in 0..<n:
        if r.low[i] > r.high[i]:
            return false
    return true

func contains[N](r:Rectangle[N], vert:Point[N]): bool =
    for i in 0..N.high:
        if vert[i] < r.low[i] or vert[i] > r.high[i]:
            return false
    return true

func index[N](ru:RectangleUnion[N], vert:Point[N]): int =
    for i,r in ru.rectangles:
        if vert in r:
            return i
    return -1

func contained[N](ru:RectangleUnion[N], r:Rectangle[N]): bool =
    let a = ru.index r.low
    if a == -1: return false
    a == ru.index r.high

proc `*=`*[N](ru: var RectangleUnion[N], r2: Rectangle[N]) =
    let n = N.high+1
    var r1i = 0
    while r1i < ru.rectangles.len:
        let r1 = ru.rectangles[r1i]
        var newRect: Rectangle[N]
        for i in 0..<n:
            newRect.low[i] = max(r1.low[i], r2.low[i])
            newRect.high[i] = min(r1.high[i], r2.high[i])
        if newRect.nonzero:
            ru.rectangles[r1i] = newRect
            inc r1i
        else:
            ru.rectangles.del r1i

func `*`*[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    result = ru
    result *= r2

func disjoint[N](r1, r2: Rectangle[N]): bool =
    for i in 0..N.high:
        if r1.low[i] > r2.high[i] or r1.high[i] < r2.low[i]:
            return true

proc `-=`*[N](ru: var RectangleUnion[N], r2: Rectangle[N]) =
    let n = N.high+1
    iterator rangesOutside(r1, r2: (int,int)): (int,int) =
        if r1[0] < r2[0]:
            yield (r1[0], min(r1[1], r2[0]-1))
        if r1[1] > r2[1]:
            yield (max(r1[0], r2[1]+1), r1[1])
    func rangeInside(r1, r2: (int,int)): (int,int) =
        (max(r1[0], r2[0]), min(r1[1], r2[1]))
    var r1i = 0
    while r1i < ru.rectangles.len:
        var r1 = ru.rectangles[r1i]
        var coordinate = 0
        if disjoint(r1, r2):inc r1i;continue
        ru.rectangles.del r1i
        while r1.nonzero and coordinate < n:
            for (l,h) in rangesOutside(r1[coordinate], r2[coordinate]):
                var copy = r1
                copy.low[coordinate] = l
                copy.high[coordinate] = h
                ru.rectangles.add copy
            let (l,h) = rangeInside(r1[coordinate], r2[coordinate])
            r1.low[coordinate] = l
            r1.high[coordinate] = h
            inc coordinate

func `-`*[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    result = ru
    result -= r2

proc `+=`*[N](ru: var RectangleUnion[N], r2: Rectangle[N]) =
    ru -= r2
    ru.rectangles.add r2

func `+`*[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    result = ru
    result += r2

func card*[N](ru: Rectangle[N]): int =
    mapIt(N.low..N.high, ru.high[it]-ru.low[it]+1).prod

func card*[N](ru: RectangleUnion[N]): int =
    ru.rectangles.map(card).sum

func `^>`*[N](a,b:array[N,int]):Rectangle[N] = (a,b)