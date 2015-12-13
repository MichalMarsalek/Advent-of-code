def solve(input):
    for i in range(50):
        input = extend(input)
        if i == 9:
            part1 = len(input)
    part2 = len(input)
    return part1, part2
    
def extend(string):
    new = ""
    last_char = string[0]
    last_count = 1
    for char in string[1:]:
        if char == last_char:
            last_count += 1
        else:
            new += str(last_count) + last_char
            last_char = char
            last_count = 1
    new += str(last_count) + last_char
    return new

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(10)