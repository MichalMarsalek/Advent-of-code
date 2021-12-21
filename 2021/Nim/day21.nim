include aoc
import memo

day 21:
    part 1,int:
        var positions = [ints[1],ints[3]]
        var scores = [0,0]
        var turn = 0
        var dice = 100
        var countRolls = 0
        proc roll(rep:int):int =
            for _ in 1..rep:
                if dice == 100:
                    dice = 0
                inc dice
                inc countRolls
                result += dice
        while true:
            positions[turn] = (positions[turn] + roll(3) + 9) mod 10 + 1
            scores[turn] += positions[turn]
            if scores[turn] >= 1000:
                return scores[1-turn] * countRolls
            turn = 1 - turn
    part 2:
        var positions = [ints[1],ints[3]]
        var rolls: seq[int]
        for a in [1,2,3]:
            for b in [1,2,3]:
                for c in [1,2,3]:
                    rolls.add a+b+c
        func countWins(pos, score: array[2,int], turn:int): int {.memoized.} =
            if turn == 0 and score[1] >= 21: return 0
            if turn == 1 and score[0] >= 21: return 1
            for roll in rolls:
                var pos2 = pos
                var score2 = score
                pos2[turn] = (pos[turn] + roll - 1) mod 10 + 1
                score2[turn] += pos2[turn]
                result += countWins(pos2, score2, 1-turn)
        
        countWins([ints[1], ints[3]], [0, 0], 0)