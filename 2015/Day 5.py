import re

def solve(input):
    part1 = sum(map(is_nice1, input.split("\n")))
    part2 = sum(map(is_nice2, input.split("\n")))
    return part1, part2

def is_nice1(string):
    vowels = "aeiou"
    forbiddens = "ab", "cd", "pq", "xy"
    v_count = sum(string.count(char) for char in vowels)
    if v_count < 3:
        return False
    f_count = sum(forbidden in string for forbidden in forbiddens)
    if f_count > 0:
        return False
    for i in range(1, len(string)):
        if string[i] == string[i-1]:
            return True
    return False

def is_nice2(string):
    pat1 = re.compile(r"(..).*\1")
    pat2 = re.compile(r"(.).\1")
    return pat1.search(string) is not None and pat2.search(string) is not None

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(5)
