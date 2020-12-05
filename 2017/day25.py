from aoc import *

def solve(inp):
    tape = [0] * 100000
    state = "A"
    slot = 0
    for i in range(12425180):
        if state == "A":
            if tape[slot] ==  0:
                tape[slot] = 1
                slot += 1
                state = "B"
            else:
                tape[slot] = 0
                slot += 1
                state = "F"

        elif state == "B":
            if tape[slot] ==  0:
                tape[slot] = 0
                slot -= 1
                state = "B"
            else:
                tape[slot] = 1
                slot -= 1
                state = "C"

        elif state == "C":
            if tape[slot] ==  0:
                tape[slot] = 1
                slot -= 1
                state = "D"
            else:
                tape[slot] = 0
                slot += 1
                state = "C"

        elif state == "D":
            if tape[slot] ==  0:
                tape[slot] = 1
                slot -= 1
                state = "E"
            else:
                tape[slot] = 1
                slot += 1
                state = "A"

        elif state == "E":
            if tape[slot] ==  0:
                tape[slot] = 1
                slot -= 1
                state = "F"
            else:
                tape[slot] = 0.
                slot -= 1
                state = "D"

        elif state == "F":
            if tape[slot] ==  0:
                tape[slot] = 1
                slot += 1
                state = "A"
            else:
                tape[slot] = 0
                slot -= 1
                state = "E"

    part1 = sum(tape)
    part2 = 0
    return part1, part2
        

run(solve)