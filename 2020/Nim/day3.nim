import aoc
import strutils

func solve*(input:string): (int, int) =
    let data = input.splitLines
    func trees(dx, dy: int = 1): int =
        for y in countup(0, data.len-1, dy):
            result += int(data[y][dx * y mod data[0].len] == '#')
    let part1 = trees(3)
    let part2 = trees(1)*trees(3)*trees(5)*trees(7)*trees(1, 3)
    return (part1, part2)
                