def solve(input):
    part1 = find_next(input)
    part2 = find_next(part1)
    return part1, part2

def find_next(password):
    while 1:
        password = increment(password)
        if is_ok(password):
            break
    return password

def increment(password):
    password = list(password)
    for i in range(1, len(password)+1):
        if password[-i] == "z":
            password[-i] = "a"
        else:
            password[-i] = chr(ord(password[-i]) + 1 + (password[-i] in "hnk"))
            break
    return "".join(password)
    
def is_ok(password):
    straight = 1
    straights = 0
    first_pair = None
    pairs = 0
    last_char = password[0]
    for char in password[1:]:
        if char in "iol":
            return False
        if chr(ord(last_char) + 1) == char:
            straight += 1
            straights += straight == 3
            if straight == 3:
        else:
            straight = 1
        if last_char == char and char != first_pair:
            first_pair = char
            pairs += 1
        last_char = char
    return straights and pairs > 1

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(11)