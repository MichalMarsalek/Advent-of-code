def solve(input):
    input = input.replace("turn ", "").replace(",", " ").replace("through ", "")
    part1 = sum(map(sum, turn_lights(input, bitwise)))
    part2 = sum(map(sum, turn_lights(input, brightness)))
    return part1, part2
    
def turn_lights(input, rule_f):
    field = [[False for x in range(1000)] for x in range(1000)]
    for line in input.split("\n"):
        cmd, x, y, X, Y = line.split(" ")
        for xi in range(int(x), int(X)+1):
            for yi in range(int(y), int(Y)+1):
                field[yi][xi] = rule_f(field[yi][xi], cmd)

def bitwise(val, cmd):
    return not val if cmd == "toggle" else cmd == "on"

def brightness(val, cmd):
    return max(0, val + {"off": -1, "on": 1, "toggle": 2}[cmd])

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(6)
