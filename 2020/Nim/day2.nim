import aoc
import strutils

solution:
    let data = input.grid
    part1:
        for l,h,c,pas in data:
            if l.parseInt <= pas.count(c) and pas.count(c) <= h.parseInt:
                result += 1
    part2:
        for l,h,c,pas in data:
            if pas[l.parseInt-1] == c or pas[h.parseInt-1]:
                result += 1
            if pas[l.parseInt-1] == c and pas[h.parseInt-1]:
                result -= 1
                