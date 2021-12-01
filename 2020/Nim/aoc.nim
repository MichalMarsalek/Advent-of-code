include prelude
import re, strutils, sequtils

func grid*(data:string, sep:string = ""): seq[seq[string]] =
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

func parseInts*(data:string): seq[int] =
    data.findAll(re"-?\d+").map(parseInt)

func intgrid*(data:string): seq[seq[int]] =
    data.splitLines.map(parseInts)

template day*(d:int, solution:untyped):untyped =
    block:
        const DAY = d
        let input = readFile(fmt"inputs\\day{DAY}.in").strip
        let ints  = input.parseInts
        solution
        
        if isMainModule:
            echo("Part 1: ", part1Proc())
            echo("Part 2: ", part2Proc())

template part1*(t:type, solution:untyped):untyped =
    proc part1Proc():t =
        solution
template part2*(t:type, solution:untyped):untyped =
    proc part2Proc():t =
        solution

template part1*(solution:untyped):untyped = part1(string, solution)
template part2*(solution:untyped):untyped = part2(string, solution)