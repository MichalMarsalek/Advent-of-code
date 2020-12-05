IT = 0
def solve(input):
    containers = list(map(int, input.split("\n")))
    posses = find(containers, 150)
    minlen = min(map(len, posses))
    posses2 = [x for x in posses if len(x) == minlen]
    part1 = len(posses)
    part2 = len(posses2)
    return part1, part2

def find(containers, volume):
    global IT
    IT += 1
    fitting = [cont for i, cont in enumerate(containers) if cont <= volume and sum(containers[i:]) >= volume]
    if len(fitting) == 0:
        if volume == 0:
            return [[]]
        return None
    suma = []
    for i, cont in enumerate(containers):
        if cont not in fitting:
            continue
        sols = find(containers[i+1:], volume - cont)
        if sols is None:
            continue
        for sol in sols:
            suma.append([cont] + sol)
    return suma

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(17)
print(IT)