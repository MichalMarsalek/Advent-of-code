def solve(input):
    part1 = len(visit(input))
    part2 = len(visit(input[::2]) | visit(input[1::2]))
    return part1, part2

def visit(route):
    houses = set([(0,0)])
    x, y = 0, 0
    dirs = {"<": (-1, 0), ">": (1, 0), "^": (0, 1), "v": (0,-1)}
    for char in route:    
        sx, sy = dirs[char]
        x += sx
        y += sy
        houses.add((x,y))
    return houses

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(3)
