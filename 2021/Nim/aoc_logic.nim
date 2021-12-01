include prelude
import re, macros, httpclient, net

var SOLUTIONS*: Table[int, proc (x:string):(string, string)]

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
        SOLUTIONS[day] = proc (input: string):(string,string) =
            var input   {.inject.} = input
            var ints    {.inject.} = input.ints
            var intgrid {.inject.} = input.intgrid
            var lines   {.inject.} = input.splitLines
            solution        
            return ($part1Proc(), $part2Proc())
        
    if isMainModule:
        run day

template part1*(t=auto, solution:untyped):untyped =
    proc part1Proc():t =
        solution
template part2*(t=auto, solution:untyped):untyped =
    proc part2Proc():t =
        solution

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
    let results = SOLUTIONS[day](getInput day)
    echo fmt"""Day {day}
    Part 1: {results[0]}
    Part 2: {results[1]}"""