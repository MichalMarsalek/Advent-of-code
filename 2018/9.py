from aoc import *
from collections import deque

def solve(inp):
    players, marbles = introw(inp)
    part1 = game(players, marbles)
    part2 = game(players, marbles*100)        
    return part1, part2

def game(players, marbles):
    state = deque([0])
    scores = players*[0]
    for m in range(1, marbles+1):
        player = (m-1)%players
        if m % 23 == 0:
            state.rotate(-7)
            scores[player] += m + state.pop()
        else:
            state.rotate(2)
            state.append(m)
    return max(scores)

run(solve)