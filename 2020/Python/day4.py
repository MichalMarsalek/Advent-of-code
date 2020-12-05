from aoc import *

def passport(data):
    res = {}
    for entry in data.replace("\n", " ").split():
        k,v = entry.split(":")
        res[k] = v
    return res

def inrange(value, lo, hi):
    return value.isnumeric() and lo <= int(value) <= hi

def solve(inp):
    fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    passports = [passport(x) for x in inp.split("\n\n")]
    
    def check1(passport):
        return all(field in passport for field in fields)
    part1 = sum(check1(x) for x in passports)    
    
    def check2(entry):
        policies = [
            inrange(entry["byr"], 1920, 2002),
            inrange(entry["iyr"], 2010, 2020),
            inrange(entry["eyr"], 2020, 2030),
            (entry["hgt"][-2:] == "cm" and inrange(entry["hgt"][:-2], 150, 193)) or (entry["hgt"][-2:] == "in" and inrange(entry["hgt"][:-2], 59, 76)),
            entry["hcl"][0] == "#",
            len(entry["hcl"]) == 7,
            set(entry["hcl"]) <= set("#0123456789abcdef"),
            entry["ecl"] in "amb blu brn gry grn hzl oth".split(),
            len(entry["pid"]) == 9,
            set(entry["pid"]) <= set("0123456789")
        ]
        return all(policies)
    part2 = sum(check1(x) and check2(x) for x in passports)
    return part1, part2


run(solve)