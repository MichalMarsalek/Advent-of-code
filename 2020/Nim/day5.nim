import aoc
import strutils, sequtils

func solve*(input:string): (int, int) =
    let data = input.replace("F", "0").replace("B", "1").replace("L", "0").replace("R", "1")
    var seats: set[int16]
    for s in data.splitLines:
        seats.incl(fromBin[int16](s))
    let part1 = seats.toSeq.max
    for s in seats:
        if s+2 in seats and s+1 notin seats:
            return (int(part1), int(s+1))
                