from aoc import *
from collections import *

    def solve(inp):
        inp = inp.replace("bags", "bag").replace(".", "").replace("no ", "0 ")
        inp = inp.splitlines()
        inp = [x.split(" contain ") for x in inp]
        rules = defaultdict(list)
        for outter, inner in inp:
            rules[outter] = [(int(x[0]),x[2:]) for x in inner.split(", ")]
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


run(solve)