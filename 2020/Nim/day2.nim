import aoc
import strutils

func solve*(input:string): (int, int) =
    let data = input.replace("-", " ").replace(":","").grid
    var part1, part2: int
    #debugEcho input
    #debugEcho data
    for row in data: #(l,h,c,pas)
        let pas = row[3]
        let c = row[2][0]
        let count = pas.count(c)
        let low = row[0].parseInt
        let high = row[1].parseInt
        if low <= count and count <= high:
            part1 += 1
        if pas[low-1] == c xor pas[high-1] == c:
            part2 += 1
    return (part1, part2)