def solve(input):
    part1 = value(eval(input))
    part2 = value(eval(input), True)
    return part1, part2
    
def value(obj, disable_red = False):
    if isinstance(obj, str):
        return 0
    if isinstance(obj, int):
        return obj
    if isinstance(obj, dict):
        if "red" in obj.values() and disable_red:
            return 0
        return sum(value(subobj) for subobj in obj.values())
    return sum(value(subobj) for subobj in obj)

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(1)