from aoc import *

def score(player):
    return sum(x*(1+i) for i,x in enumerate(player[::-1]))

def play(player1, player2, recursive=False):
    seen = set()
    while player1 and player2:
        state = tuple(player1), tuple(player2)
        if recursive and state in seen:
            return -1
        seen.add(state)
        a = player1.pop(0)
        b = player2.pop(0)
        if recursive and len(player1) >= a and len(player2) >= b:
            if play(player1[:a], player2[:b], True) < 0:
                player1 += [a, b]
            else:
                player2 += [b, a]
        else:
            if a > b:
                player1 += [a, b]
            else:
                player2 += [b, a]
    if player1:
        return -score(player1)
    return score(player2)

def solve(inp):
    data = inp.split("\n\n")
    data = [intcolumn(x)[1:] for x in data]
    part1 = play(data[0][:], data[1][:])
    part2 = play(data[0][:], data[1][:], True)
    return part1, part2

run(solve)