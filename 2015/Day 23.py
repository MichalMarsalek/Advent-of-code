def solve(input):
    program = input.split("\n")
    a, b = interpret(program, 0, 0, 0)
    part1 = b
    a, b = interpret(program, 0, 1, 0)
    part2 = b
    return part1, part2

def interpret(program, pos, a, b):
    vars = {"a": a, "b": b}    
    while pos < len(program):
        line = program[pos]
        cmd = line[:3]
        if cmd == "hlf":
            var = line[4]
            vars[var] /= 2
        elif cmd == "tpl":
            var = line[4]
            vars[var] *= 3
        elif cmd == "inc":
            var = line[4]
            vars[var] += 1
        elif cmd == "jmp":
            pos += int(line[4:])
            continue
        elif cmd == "jie":
            var = line[4]
            if vars[var] % 2 == 0:
                pos += int(line[7:])
                continue
        elif cmd == "jio":
            var = line[4]
            if vars[var] == 1:
                pos += int(line[7:])
                continue
        pos += 1
    return vars["a"], vars["b"]
def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(23)
