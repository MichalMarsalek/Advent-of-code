from hashlib import md5

def solve(input):
    part1 = find(input, "00000")
    part2 = find(input, "000000")
    return part1, part2

def find(string, startswith):
    i = 0
    while 1:
        if md5((string + str(i)).encode()).hexdigest().startswith(startswith):
            break
        i += 1
    return i
    
def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(4)
