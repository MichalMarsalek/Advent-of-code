import aoc
import strutils

solution:
    let data = input.column
    func trees(dx, dy=1: int): int =
        for y in countup(0, data.len, dy):
            result += int(data[y][dx * y div dy] == '#')
    part1:
        trees(3)
    part2:
        trees(1)*trees(3)*trees(5)*trees(7)*trees(1, 3)
                