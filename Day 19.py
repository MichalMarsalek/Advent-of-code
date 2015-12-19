import re

def solve(input):
    repls, molecule = input.split("\n\n")
    repls = [repl.split(" => ") for repl in repls.split("\n")]
    part1 = solve1(repls, molecule)
    part2 = solve2(repls, molecule)
    return part1, part2

def solve1(repls, molecule):
    molecules = set()
    for find, repl in repls:
        molecules.update(get_replaces(molecule, find, repl))
    return len(molecules)    

def get_replaces(string, find, repl):
    indexes = [m.start() for m in re.finditer(find, string)]
    return [string[:i] + repl + string[i+len(find):] for i in indexes]

def solve2(repls, molecule):
    repls.sort(key= lambda x: -len(x[1]))
    step = 1
    while True:
        for repl in repls:
            if repl[1] not in molecule:
                continue
            molecule = molecule.replace(repl[1], repl[0], 1)
            if molecule == "e":
                return step
            break
        step += 1
    return step

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(19)