include prelude
import re, macros, httpclient, net, algorithm, times

var SOLUTIONS*: Table[int, proc (x:string):Table[int,string]]

const
 directions8 = [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]
 directions4 = [(0, -1), (1, 0), (0, 1), (-1, 0)]


func drop[T](s: seq[T], d: int):seq[T] = s[d..^1]

func grid*(data:string, sep:string = ""): seq[seq[string]] =
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

func ints*(data:string): seq[int] =
    data.findAll(re"-?\d+").map(parseInt)

func intgrid*(data:string): seq[seq[int]] =
    data.splitLines.map(ints)

template day*(day:int, solution:untyped):untyped =
    block:
        SOLUTIONS[day] = proc (input: string):Table[int,string] =
            var input   {.inject.} = input
            var ints    {.inject.} = input.ints
            var lines   {.inject.} = input.splitLines
            var parts   {.inject.}: Table[int, proc ():string]
            solution
            for k,v in parts:
                result[k] = $v()
        
    if isMainModule:
        run day

template part*(p:int, t=auto, solution:untyped):untyped =
    parts[p] = proc ():string =
        proc inner():t =
            solution
        return $inner()

proc getInput(day: int): string =
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
    let start = cpuTime()
    let results = SOLUTIONS[day](getInput day)
    let finish = cpuTime()
    echo "Day "& $day
    for k in results.keys.toSeq.sorted:
        echo fmt" Part {k}: {results[k]}"
    echo fmt" Time: {finish-start:.2} s"