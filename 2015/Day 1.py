def solve(input):
    part1 = input.count("(") - input.count(")")
    pos = 0
    for part2, char in enumerate(input):
        pos += 1 if char == "(" else -1
        if pos < 0:
            break
    return part1, part2
    
def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(1)
