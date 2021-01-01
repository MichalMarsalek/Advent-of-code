import aoc
import strutils, sequtils, tables


func solve*(input:string): (string, string) =
    var right = initTable[int32, int32]()
    func nxt(curr, mn, mx:int32):int32 =
        let a = right[curr]
        let b = right[a]
        let c = right[b]
        right[curr] = right[c]
        var dest = curr
        while dest == curr or dest in [a, b, c]:
            dec dest
            if dest < mn:
                dest = mx
        right[c] = right[dest]
        right[dest] = a
        return right[curr]
    let data = input.mapIt(($it).parseInt.int32)
    for i in 0..8:
        right[data[i]] = data[(i+1) mod 9]
    var curr = data[0]
    for _ in 1..100:
        curr = nxt(curr, min(data), max(data))
    var part1 = ""
    curr = right[1]
    while curr != 1:
        part1 &= $curr
        curr = right[curr]
    
    for i in 0..7:
        right[data[i]] = data[i+1]
    right[data[^1]] = max(data)+1
    for i in (max(data)+1)..<1000000:
        right[i] = i+1
    right[1000000] = data[0]  
    curr = data[0]
    for _ in 1..10000000:
        curr = nxt(curr, 1, 1000000)
    let part2 = right[1].int * right[right[1]].int
    return (part1, $part2)