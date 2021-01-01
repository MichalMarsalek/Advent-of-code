import aoc
import strutils, sequtils

func toSet(ans: string): set[char] =
    for c in ans:
        result.incl(c)

func solve*(input:string): (int, int) =
    let data = input.split("\n\n")
    var part1, part2: int
    for group in data:
        var union, intersection: set[char]
        for person in group.splitLines:
            let personAns = person.toSet
            union = union + personAns
            if intersection.card == 0:
                intersection = personAns
            else:
                intersection = intersection * personAns
        part1 += union.card
        part2 += intersection.card
    return (part1, part2)
                