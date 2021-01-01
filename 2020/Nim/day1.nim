import aoc

func solve*(input:string): (int, int) =
    var numbers: set[int16]
    for n in input.parseInts:
        numbers.incl(n.int16)
    var part1, part2: int
    for a in numbers:
        for b in numbers - {a}:
            if a + b == 2020:
                part1 = a.int * b.int
            let c = 2020 - a - b
            if c in numbers:
                part2 = a.int * b.int * c.int
    return (part1, part2)