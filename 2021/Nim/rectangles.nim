import sequtils

type Rectangle[N] = tuple[low,high:array[N,int]]
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

func `*`[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    let n = N.high+1
    for r1 in ru.rectangles:
        var newRect: Rectangle[N]
        for i in 0..<n:
            newRect.low[i] = max(r1.low[i], r2.low[i])
            newRect.high[i] = min(r1.high[i], r2.high[i])
        if newRect.nonzero:
            result.rectangles.add newRect

func `*`*[N](ru: RectangleUnion[N], ru2: RectangleUnion[N]): RectangleUnion[N] =
    assert ru2.rectangles.len == 1, "Intersection of general RectangleUnions not implemented yet."
    ru * ru2.rectangles[0]

func `-`[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    let n = N.high+1
    iterator rangesOutside(r1, r2: (int,int)): (int,int) =
        if r1[0] < r2[0]:
            yield (r1[0], min(r1[1], r2[0]-1))
        if r1[1] > r2[1]:
            yield (max(r1[0], r2[1]+1), r1[1])
    func rangeInside(r1, r2: (int,int)): (int,int) =
        (max(r1[0], r2[0]), min(r1[1], r2[1]))
    for r1 in ru.rectangles:
        var r1 = r1
        var coordinate = 0
        while r1.nonzero and coordinate < n:
            for (l,h) in rangesOutside(r1[coordinate], r2[coordinate]):
                var copy = r1
                copy.low[coordinate] = l
                copy.high[coordinate] = h
                result.rectangles.add copy
            let (l,h) = rangeInside(r1[coordinate], r2[coordinate])
            r1.low[coordinate] = l
            r1.high[coordinate] = h
            inc coordinate

func `-`*[N](ru: RectangleUnion[N], ru2: RectangleUnion[N]): RectangleUnion[N] =
    assert ru2.rectangles.len == 1, "Difference of general RectangleUnions not implemented yet."
    ru - ru2.rectangles[0]

func `+`[N](ru: RectangleUnion[N], r2: Rectangle[N]): RectangleUnion[N] =
    result = ru - r2
    result.rectangles.add r2
func `+`*[N](ru: RectangleUnion[N], ru2: RectangleUnion[N]): RectangleUnion[N] =
    assert ru2.rectangles.len == 1, "Union of general RectangleUnions not implemented yet."
    ru + ru2.rectangles[0]

func card*[N](ru: Rectangle[N]): int =
    mapIt(0..N.high, ru.high[it]-ru.low[it]+1).prod

func card*[N](ru: RectangleUnion[N]): int =
    ru.rectangles.map(card).sum

func `^>`*[N](a,b:array[N,int]):RectangleUnion[N] =
    RectangleUnion[N](rectangles: @[(a,b)])