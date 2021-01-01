import re, strutils, sequtils

#func toSet*[A](data:seq[A]): set[A] =
#    for x in data:
#        result.incl(x)

func grid*(data:string, sep:string = ""): seq[seq[string]] =
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)    
    return data.splitLines.mapIt(it.split(sep))

func parseInts*(data:string): seq[int] =
    data.findAll(re"-?\d+").map(parseInt)

func intgrid*(data:string): seq[seq[int]] =
    data.splitLines.map(parseInts)
