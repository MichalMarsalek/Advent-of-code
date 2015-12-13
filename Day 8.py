def solve(input):
    part1 = sum(map(diff1, input.split("\n"))))
    return part1, part2
    
def diff1(string):
    result = len(string)
    escape = 0
    for char in string:
        if escape > 0:
            if escape == 1 and char == "x":
                escape += 2
            escape -= 1
            continue
        result -= 1
        if char == "\\":
            escape = 1
    return result + 2

def diff2(string):
    return sum(char in ["\\", "\""] for char in string) + 2

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(8)