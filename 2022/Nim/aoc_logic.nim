include prelude
import re, macros, httpclient, net, algorithm, times, strscans, deques, sugar
import math except sum

var SOLUTIONS*: Table[int, proc (x: string): Table[int, string]]

template day*(day: int, solution: untyped): untyped =
    ## Defines a solution function, if isMainModule, runs it.
    block:
        SOLUTIONS[day] = proc (input: string): Table[int, string] =
            var inputRaw{.inject.} = input
            var input {.inject.} = input.strip(false)
            var integers {.inject.} = input.ints
            var lines {.inject.} = input.splitLines
            var parts {.inject.}: OrderedTable[int, proc (): string]
            solution
            for k, v in parts:
                result[k] = $v()

    if isMainModule:
        run day

template part*(p: int, t: type, solution: untyped): untyped =
    ## Defines a part solution function.
    parts[p] = proc (): string =
        proc inner(): t =
            solution
        return $inner()
template part*(p: int, solution: untyped): untyped =
    ## Defines a part solution function.
    parts[p] = proc (): string =
        proc inner(): auto =
            solution
        return $inner()

## GRID and POINTS

## Common direction vectors
const
    directions9* = [(-1, -1), (0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1,
            1), (0, 1), (1, 1)]
    directions8* = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0,
            1), (1, 1)]
    directions4* = [(0, -1), (1, 0), (0, 1), (-1, 0)]

type Grid*[T] = seq[seq[T]]
type Point* = (int, int)
type Point3* = (int, int, int)
func x*(p: Point): int = p[0]
func y*(p: Point): int = p[1]
func x*(p: Point3): int = p[0]
func y*(p: Point3): int = p[1]
func z*(p: Point3): int = p[2]

func toDirection*(name: char): Point =
    case name.toUpperAscii:
        of 'U': (0, -1)
        of 'N': (0, -1)
        of 'D': (0, 1)
        of 'S': (0, 1)
        of 'L': (-1, 0)
        of 'W': (-1, 0)
        of 'R': (1, 0)
        of 'E': (1, 0)
        else: raise newException(IOError, "Unkknown direction.")

func toDirection*(name: string): Point =
    if name.len == 1: return name[0].toDirection
    case name.toUpperAscii:
        of "NW": (-1, -1)
        of "NE": (1, -1)
        of "SW": (-1, 1)
        of "SE": (1, 1)
        else: raise newException(IOError, "Unkknown direction.")

proc initGrid*[T](width, height: int): Grid[T] =
    result = newSeq[seq[T]](height)
    for y in 0..<height:
        result[y] = newSeq[T](width)
proc initGrid*[T](width, height: int, value: T): Grid[T] =
    result = newSeq[seq[T]](height)
    for y in 0..<height:
        result[y] = toSeq value.repeat width

proc transpose*[T](grid: Grid[T]): Grid[T] =
    let height = grid.mapIt(it.len).min
    result = initGrid[T](grid.len, height)
    for y in 0..<grid.height:
        for x, item in grid[y]:
            if x == height: break
            result[y, x] = item

template `[]`*[T](data: Grid[T], index: Point): T =
    data[index.y][index.x]
template `[]`*[T](data: Grid[T], x, y: int): T =
    data[y][x]
template `[]=`*[T](data: var Grid[T], index: Point, val: T) =
    data[index.y][index.x] = val
template `[]=`*[T](data: var Grid[T], x, y: int, val: T) =
    data[y][x] = val

func size*[T](data: Grid[T]): int =
    data.len * data[0].len

template `+`*(a, b: Point): Point = (a.x+b.x, a.y+b.y)
template `-`*(a: Point): Point = (-a.x, -a.y)
template `*`*(a: int, b: Point): Point = (a*b.x, a*b.y)
template map*(a: Point, f: untyped): Point = (f a.x, f a.y)
func norm1*(a: Point): int = abs(a.x) + abs(a.y)
func normMax*(a: Point): int = max(abs(a.x), abs(a.y))



template `+`*(a, b: Point3): Point3 = (a.x+b.x, a.y+b.y, a.z+b.z)
template `-`*(a: Point3): Point3 = (-a.x, -a.y, -a.z)
template `*`*(a: int, b: Point3): Point3 = (a*b.x, a*b.y, a*b.z)
template map*(a: Point3, f: untyped): Point = (f a.x, f a.y, f a.z)
func norm1*(a: Point3): int = abs(a.x) + abs(a.y) + abs(a.z)
func normMax*(a: Point3): int = max(max(abs(a.x), abs(a.y)), abs(a.z))

func rotateLeft*(a: Point): Point = (a.y, -a.x)
func rotateRight*(a: Point): Point = (-a.y, a.x)
func rotateLeft*(a: Point, amount: int): Point =
    result = a
    for _ in 1..(amount.floorMod 4):
        result = a.rotateLeft
func rotateRight*(a: Point, amount: int): Point = a.rotateLeft(-amount)

template dist1*[T: Point | Point3](a: T, b: T): int = norm1(a-b)
template distMax*[T: Point | Point3](a: T, b: T): int = normMax(a-b)
template `-`*[T: Point | Point3](a, b: T): T = a + (-b)
template `+=`*[T: Point | Point3](a: var T, b: T): untyped = a = a + b
template `-=`*[T: Point | Point3](a: var T, b: T): untyped = a = a - b



func drop*[T](s: seq[T], d: int): seq[T] =
    ## Returns s with d initial elements dropped
    s[d..^1]

func popSeq*[T](s: var seq[T], d: int, preserveOrder: bool): seq[T] =
    ## Removes d last items from s and returns them
    result = s[^d..^1]
    if not preserveOrder: reverse result
    s.setLen(s.len - d)

func grid*(data: string, sep: string = ""): Grid[string] =
    ## Splits input into 2D Grid, rows separated by NL,
    ## columns separated by sep - whitespace by default.
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

func ints*(data: string): seq[int] =
    ## Returns all ints < 10^9 present in the input text.
    data.findAll(re"-?\d+").filterIt(it.len <= 18).map(parseInt)

##TODO make this general using macros
func ints1*(data: string): int =
    ## Returns the first int < 10^9 present in the input text.
    data.ints[0]
func ints2*(data: string): auto =
    ## Returns the first two ints < 10^9 present in the input text.
    let ints = data.ints
    (ints[0], ints[1])
func ints3*(data: string): auto =
    ## Returns the first three ints < 10^9 present in the input text.
    let ints = data.ints
    (ints[0], ints[1], ints[2])
func ints4*(data: string): auto =
    ## Returns the first four ints < 10^9 present in the input text.
    let ints = data.ints
    (ints[0], ints[1], ints[2], ints[3])
func ints5*(data: string): auto =
    ## Returns the first five ints < 10^9 present in the input text.
    let ints = data.ints
    (ints[0], ints[1], ints[2], ints[3], ints[4])
func ints6*(data: string): auto =
    ## Returns the first six ints < 10^9 present in the input text.
    let ints = data.ints
    (ints[0], ints[1], ints[2], ints[3], ints[4], ints[5])

func intGrid*(data: string): Grid[int] =
    ## Returns a matrix of ints present in the input text
    data.splitLines.map(ints)

# TODO make this general
macro mapTuple*[T1, T2](x: seq[(T1, T2)], expr: untyped): untyped =
    quote do:
        collect:
            for el in `x`:
                let (a {.inject.}, b {.inject.}) = el
                `expr`

macro mapTuple*[T1, T2, T3](x: seq[(T1, T2, T3)], expr: untyped): untyped =
    quote do:
        collect:
            for el in `x`:
                let (a {.inject.}, b {.inject.}, c {.inject.}) = el
                `expr`

macro mapTuple*[T1, T2, T3, T4](x: seq[(T1, T2, T3, T4)], expr: untyped): untyped =
    quote do:
        collect:
            for el in `x`:
                let (a {.inject.}, b {.inject.}, c {.inject.}, d {.inject.}) = el
                `expr`

macro mapTuple*[T1, T2, T3, T4, T5](x: seq[(T1, T2, T3, T4, T5)], expr: untyped): untyped =
    quote do:
        collect:
            for el in `x`:
                let (a {.inject.}, b {.inject.}, c {.inject.}, d {.inject.}, e {.inject.}) = el
                `expr`

macro mapTuple*[T1, T2, T3, T4, T5, T6](x: seq[(T1, T2, T3, T4, T5, T6)], expr: untyped): untyped =
    quote do:
        collect:
            for el in `x`:
                let (a {.inject.}, b {.inject.}, c {.inject.}, d {.inject.}, e {.inject.}, f {.inject.}) = el
                `expr`

proc getInput(day: int): string =
    ## Downloads an input for given day, saves it on disk and returns it,
    ## unless it's been downloaded before, in which case loads it from the disk.
    let filename = fmt"inputs\\day{day}.in"
    if fileExists filename:
        return readFile filename
    echo fmt"Downloading input for day {day}."
    let ctx = newContext(cafile = "cacert.pem")
    let client = newHttpClient(userAgent = "https://github.com/MichalMarsalek/Advent-of-code by Michal.Marsalek4@gmail.com",
            sslContext = ctx)
    client.headers["cookie"] = readFile "session"
    let input = client.getContent(fmt"https://adventofcode.com/2022/day/{day}/input")
    filename.writeFile(input)
    return input

proc run*(day: int) =
    ## Runs given day solution on the corresponding input.
    let start = cpuTime()
    let results = SOLUTIONS[day](getInput day)
    let finish = cpuTime()
    echo "Day " & $day
    for k in results.keys.toSeq.sorted:
        echo fmt" Part {k}: {results[k]}"
    echo fmt" Time: {finish-start:.2} s"

func modInv*(a0, modulus: int): int =
    ## Returns a modular inverse of a0 to the given modulus.
    ## That is result * a0 mod modulus == 1 always hold.
    ## If a0 is not invertible, raises an error (TODO)
    var (a, b, x0) = (a0, modulus, 0)
    result = 1
    if b == 1: return
    while a > 1:
        result = result - (a div b) * x0
        a = a mod b
        swap a, b
        swap x0, result
    if result < 0: result += modulus

func modSum*(data: openarray[int], modulus: int): int =
    ## Returns data.sum mod modulus, but less likely to overflow.
    for x in data:
        result = (result + x) mod modulus

func modProd*(data: openarray[int], modulus: int): int =
    ## Returns data.prod mod modulus, but less likely to overflow.
    result = 1
    for x in data:
        result = (result * x) mod modulus

func crt*(data: seq[(int, int)]): int =
    ## Solves the CRT system of equations. That is, returns
    ## result, s.t. result in 0..<big_mod,
    ## result mod data[i][1] == data[i][0] for all i
    ## where big_mod = data[0][1] * ... * data[^1][1]
    var big_mod = data.mapIt(it[1]).prod
    for v, m in data.items:
        let p = big_mod div m
        result = (result + v * modInv(p, m) * p) mod big_mod

func median*[T](data: seq[T]): T =
    data.sorted[data.len div 2]
func medianHigh*[T](data: seq[T]): T =
    data.sorted[data.len div 2 + 1]


template height*(data: Grid): int = len data
template width*(data: Grid): int = len data[0]

iterator neighbours*(p: Point, directions: openarray[
        Point] = directions4): Point =
    ## Returns all neighbours of a lattice point.
    for d in directions:
        yield p+d

func contains*(grid: Grid, p: Point): bool =
    p.y in 0..<grid.height and p.x in 0..<grid[p.y].len

iterator neighbours*[T](data: Grid[T], p: Point,
                        directions: openarray[Point] = directions4): Point =
    ## Returns all neighbours of a lattice that
    ## are a valid indeces to the given data.
    for neigh in neighbours(p, directions):
        if neigh in data:
            yield neigh

func neighboursRec*[T](data: Grid[T], p: Point, pred: proc (a, b: T): bool,
                      directions: openarray[Point] = directions4): Table[Point, int] =
    ## Returns a table, in which each recursive neigbour of the
    ## given point is mapped to the least number of steps it takes.
    ## The predicate pred restricts the neighbourness condition.
    var q = [(p, 0)].toDeque
    while q.len > 0:
        var (p, d) = q.popFirst
        result[p] = d
        for P in data.neighbours(p, directions):
            if pred(data[p], data[P]):
                if P notin result:
                    q.addLast (P, d+1)

iterator coordinates*[T](data: Grid[T]): Point =
    ## Yields all valid coordinates for the given grid.
    for y in 0..<data.height:
        for x in 0..<data.width:
            yield (x, y)

iterator pairs*[T](data: Grid[T]): (Point, T) =
    ## Yields all pairs of coordinate and value.
    for c in data.coordinates:
        yield (c, data[c])

func continuousAreas*[T](data: Grid[T], pred: proc (a, b: T): bool,
                         directions: openarray[Point] = directions4): seq[
                                 HashSet[Point]] =
    ## Returns a seq that forms a disjoint union of the Grid data,
    ## based on the pre predicate -  see neighboursRec.
    var visited: HashSet[Point]
    for p in data.coordinates:
        if p in visited:
            continue
        let area = data.neighboursRec(p, pred, directions).keys.toSeq.toHashSet
        visited = visited + area
        result.add area

func plot*(points: openarray[Point], header = true): string =
    ## Plots a list of points to a 2D grid,
    ## returns string representing the grid.
    let xRange = points.map(x).min..points.map(x).max
    let yRange = points.map(y).min..points.map(y).max
    if header:
        result = "Y = " & $yRange & ", X = " & $xRange & "\n"
    for y in yRange:
        if y > 0: result &= '\n'
        for x in xRange:
            if (x, y) in points:
                result &= "#"
            else:
                result &= " "

func `^`*[T](fun: T -> T, exp: int): (T -> T) =
    return proc(inp: T): T =
        result = inp
        for _ in 1..exp:
            result = fun result

func `*`*[T1, T2, T3](fun2: T2 -> T3, fun1: T1 -> T2): (T1 -> T3) =
    return proc(inp: T1): T3 =
        fun2 fun1 inp

func distribute*(text: string, num: Positive, spread = true): seq[string] =
    text.toSeq.distribute(num, spread).mapIt(it.join)

func groupsOf*[T](data: seq[T], groupSize: Positive): seq[seq[T]] =
    data.distribute(data.len div groupSize)
func groupsOf*[T](data: string, groupSize: Positive): seq[string] =
    data.distribute(data.len div groupSize)

func `mod`*[T: SomeNumber](x, y: T): T = x.floorMod y

template sum*(body: untyped{nkForStmt}): untyped =
    math.sum collect body

template sum*(x: untyped): untyped =
    math.sum x

#it's not possible to name these "min" and "max" since these symbols are automatically imported from system module
template minc*(body: untyped{nkForStmt}): untyped =
    min collect body

template maxc*(body: untyped{nkForStmt}): untyped =
    max collect body

macro eval*(value: static[string]): untyped = parseStmt value

#type DefaultTable*[A; B; D: static B] = Table[A, B]
#
#proc `[]`*[A, B, D](t: DefaultTable[A, B, D]; key: A): B =
#    t.getOrDefault(key, D)

type Font = Table[string, char]

func splitToCharacters(display: string): seq[string] =
    var display = splitLines(display).mapIt(it & " ")
    var prev = -1
    for x in 0..<display[0].len:
        if display.allIt(it[x] == ' '):
            if x > prev + 1:
                result &= display.mapIt(it[prev+1..<x]).join "\n"
            prev = x

func initFont(letters: string, glyphs: string): Font =
    var glyphs = splitToCharacters glyphs
    zip(glyphs, letters).toTable

const FONT1 = initFont("ABCEFGHIJKLOPRSUYZ", """
 ##  ###   ##  #### ####  ##  #  # ###   ## #  # #     ##  ###  ###   ### #  # #   # ####
#  # #  # #  # #    #    #  # #  #  #     # # #  #    #  # #  # #  # #    #  # #   #    #
#  # ###  #    ###  ###  #    ####  #     # ##   #    #  # #  # #  # #    #  #  # #    # 
#### #  # #    #    #    # ## #  #  #     # # #  #    #  # ###  ###   ##  #  #   #    #  
#  # #  # #  # #    #    #  # #  #  #  #  # # #  #    #  # #    # #     # #  #   #   #   
#  # ###   ##  #### #     ### #  # ###  ##  #  # ####  ##  #    #  # ###   ##    #   ####""")

func ocr*(display: string, font = FONT1): string =
    try:
        display.splitToCharacters.mapIt(font[it]).join
    except:
        "OCR failed, pixels are\n" & display


func ocr*(pixels: seq[Point], font = FONT1): string =
    plot(pixels, false).ocr(font)
