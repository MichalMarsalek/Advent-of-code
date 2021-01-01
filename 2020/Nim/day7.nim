import aoc
import strutils, sequtils, tables

func solve*(input:string): (int, int) =
    let data = input.replace("bags", "bag").replace(".", "").replace("no ", "0 ").grid(" contain ")
    var rules = initTable[seq[(int, string)]]()
    for (outter, inner) in data:
        rules[outter] = inner.split(", ").mapIt((int(it[0]),it[2:]))
    #[
    def can_hold(o, bag):
        if o == bag:
            return True
        return any(can_hold(i, bag) for c,i in rules[o])
    bags = set(rules.keys())
    p1 = {bag for bag in bags if can_hold(bag, "shiny gold bag")}
    part1 = len(p1-{"shiny gold bag"})
    def how_many(o):
        return sum(c + c * how_many(i) for c,i in rules[o])
    part2 = how_many("shiny gold bag")
    return part1, part2
    return (part1, part2)  ]#
                