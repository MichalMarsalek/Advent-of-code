def solve(input):
    parts = input.replace(".", "").replace(",", "").split()
    col = int(parts[-1])
    row = int(parts[-3])
    n1 = 20151125
    a = 252533
    e = sum(range(col + row)) - row
    m = 33554393
    part1 = (pow(a, e, m) * n1) % m
    part2 = 0
    return part1, part2

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(25)

