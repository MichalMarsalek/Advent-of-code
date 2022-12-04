include aoc

day 2:
    let rounds = lines.mapIt (
            it[0].ord - 'A'.ord,
            it[2].ord - 'X'.ord
        )
    func score(a, b: int): int =
        ((b - a + 4) mod 3) * 3 + b + 1
    part 1: sum(for (a, b) in rounds: score(a, b))
    part 2: sum(for (a, b) in rounds: score(a, (a + b + 2) mod 3))
