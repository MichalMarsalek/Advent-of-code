def solve(input):
    boxes = input.split("\n")
    part1 = sum(map(paper, boxes))
    part2 = sum(map(ribbon, boxes))
    return part1, part2

def paper(box):
    a, b, c = [int(x) for x in box.split("x")]
    sides = a*b, b*c, a*c
    return 2 * sum(sides) + min(sides)

def ribbon(box):
    a, b, c = [int(x) for x in box.split("x")]
    sides = 2*(a+b), 2*(a+c), 2*(b+c)
    return min(sides) + a*b*c

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(2)
