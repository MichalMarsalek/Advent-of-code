def solve(input):
    mySue = {"children": 3, "cats": 7, "samoyeds": 2, "pomeranians": 3, "akitas": 0, "vizslas": 0, "goldfish": 5, "trees": 3, "cars": 2, "perfumes": 1}
    Sues = {name: {prop: int(value) for prop, value in [x.split(": ") for x in props.split(", ")]} for name, props in [y.split(": ", 1) for y in input.split("\n")]}
    for Sue in Sues:
        if all(compare(mySue, Sues[Sue], prop) for prop in Sues[Sue]):
            part1 = Sue
        if all(compare(mySue, Sues[Sue], prop, True) for prop in Sues[Sue]):
            part2 = Sue
    return part1, part2

def compare(mySue, Sue, prop, betterCompare = False):
    if betterCompare:
        if prop in ("cats", "trees"):
            return mySue[prop] < Sue[prop]
        elif prop in ("pomeranians", "goldfish"):
            return mySue[prop] > Sue[prop]
    return mySue[prop] == Sue[prop]

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(16)