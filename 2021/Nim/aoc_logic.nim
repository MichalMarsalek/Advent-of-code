include prelude
import re, macros, httpclient, net, algorithm, times, math, strscans, deques

var SOLUTIONS*: Table[int, proc (x:string):Table[int,string]]

template day*(day:int, solution:untyped):untyped =
    ## Defines a solution function, if isMainModule, runs it.
    block:
        SOLUTIONS[day] = proc (input: string):Table[int,string] =
            var inputRaw{.inject.} = input
            var input   {.inject.} = input.strip
            var ints    {.inject.} = input.ints
            var lines   {.inject.} = input.splitLines
            var parts   {.inject.}: Table[int, proc ():string]
            solution
            for k,v in parts:
                result[k] = $v()
        
    if isMainModule:
        run day

template part*(p:int, t=auto, solution:untyped):untyped =
    ## Defines a part solution function.
    parts[p] = proc ():string =
        proc inner():t =
            solution
        return $inner()


## Common direction vectors
const
 directions8* = [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]
 directions4* = [(0, -1), (1, 0), (0, 1), (-1, 0)]


func drop*[T](s: seq[T], d: int):seq[T] =
    ## Returns s with d initial elements dropped
    s[d..^1]

func grid*(data:string, sep:string = ""): seq[seq[string]] =
    ## Splits input into 2D grid, rows separated by NL,
    ## columns separated by sep - whitespace by default.
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

func ints*(data:string): seq[int] =
    ## Returns all ints < 10^9 present in the input text.
    data.findAll(re"-?\d+").filterIt(it.len <= 18).map(parseInt)

func intgrid*(data:string): seq[seq[int]] =
    ## Returns a matrix of ints present in the input text
    data.splitLines.map(ints)

proc getInput(day: int): string =
    ## Downloads an input for given day, saves it on disk and returns it,
    ## unless it's been downloaded before, in which case loads it from the disk.
    let filename = fmt"inputs\\day{day}.in"
    if fileExists filename:
        return readFile filename
    echo fmt"Downloading input for day {day}."
    let ctx = newContext(cafile ="cacert.pem")
    let client = newHttpClient(sslContext = ctx)
    client.headers["cookie"] = readFile "session"
    let input = client.getContent(fmt"https://adventofcode.com/2021/day/{day}/input")
    filename.writeFile(input)
    return input        

proc run*(day: int) =
    ## Runs given day solution on the corresponding input.
    let start = cpuTime()
    let results = SOLUTIONS[day](getInput day)
    let finish = cpuTime()
    echo "Day "& $day
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

func modSum*(data: openarray[int], modulus:int): int =
    ## Returns data.sum mod modulus, but less likely to overflow.
    for x in data:
        result = (result + x) mod modulus

func modProd*(data: openarray[int], modulus:int): int =
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


func `[]`*[T](data:seq[seq[T]], index:(int,int)):T =
    data[index[1]][index[0]]
func `[]`*[T](data:seq[seq[T]], x,y:int):T =
    data[y][x]


iterator neighbours*(x,y:int,directions=directions4):(int,int) =
    ## Returns all neighbours of a lattice point.
    for (dx,dy) in directions4:
        yield (x+dx, y+dy)

iterator neighbours*[T](x,y:int, directions=directions4,
                    data:seq[seq[T]]):(int,int) =
    ## Returns all neighbours of a lattice that
    ## are a valid indeces to the given data.
    let height = len data
    let width = len data[0]
    for (X,Y) in neighbours(x,y,directions):
        if 0 <= X and X < width and 0 <= Y and Y < height:
            yield (X,Y)

func neighboursRec*[T](x,y:int, data:seq[seq[T]], pred: proc (a,b:T):bool,
                      directions=directions4): Table[(int,int),int] =
    ## Returns a table, in which each recursive neigbour of the
    ## given point is mapped to the least number of steps it takes.
    ## The predicate pred restricts the neighbourness condition.
    var q = [(x,y,0)].toDeque
    while q.len > 0:
        var (x,y,d) = q.popFirst
        result[(x,y)] = d
        for (X,Y) in neighbours(x,y, directions, data):
            if pred(data[x,y], data[X,Y]):
                if not result.hasKey((X,Y)):
                    q.addLast((X,Y,d+1))

func continuousAreas*[T](data:seq[seq[T]], pred: proc (a,b:T):bool,
                         directions=directions4): seq[HashSet[(int,int)]] =
    ## Returns a seq that forms a disjoint union of the grid data,
    ## based on the pre predicate -  see neighboursRec.
    var visited: HashSet[(int,int)]
    let height = len data
    let width = len data[0]
    for y in 0..<height:
        for x in 0..<width:
            if (x,y) in visited:
                continue
            let area = neighboursRec(x,y, data, pred, directions).keys.toSeq.toHashSet
            visited = visited + area
            result.add area

