include aoc
import memo

day 21:
    part 1,int:
        var positions = [ints[1],ints[3]]
        var scores = [0,0]
        var turn = 0
        var countRolls = 0
        proc roll(rep=1):int =
            for _ in 1..rep:
                inc countRolls
                result += (countRolls - 1) mod 100 + 1
        while true:
            positions[turn] = (positions[turn] + roll(3) - 1) mod 10 + 1
            scores[turn] += positions[turn]
            if scores[turn] >= 1000:
                return scores[1-turn] * countRolls
            turn = 1 - turn
    part 2:
        let rolls = product([@[1,2,3],@[1,2,3],@[1,2,3]]).mapIt it.sum
        func countWins(p1, p2, s1, s2: int): array[2, int] {.memoized.} =
            if s1 >= 21 or s2 >= 21:
                return [int(s1>=21), int(s2>=21)]
            for roll in rolls:
                let p = (p1 + roll - 1) mod 10 + 1
                let w = countWins(p2, p, s2, s1 + p)
                result[0] += w[1]
                result[1] += w[0]
        
        max countWins(ints[1], ints[3], 0, 0)