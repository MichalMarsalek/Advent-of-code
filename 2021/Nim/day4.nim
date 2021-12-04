include aoc

day 4:
    var
     blocks = input.split "\n\n"
     nums = blocks[0].ints
     boards = blocks[1..^1].map intgrid
     checks = boards.map(x => mapIt(0..4, newSeq[bool](5)))
     scores:seq[int]
     players = toSet toSeq(0..<boards.len)
    
    proc update(n,i: int): bool =
        for x in 0..<5:
            for y in 0..<5:
                if boards[i][x][y] == n:
                    checks[i][x][y] = true
                    if allIt(0..4, checks[i][x][it]): return true
                    if allIt(0..4, checks[i][it][y]): return true
    
    proc score(i: int):int =
        for x in 0..4:
            for y in 0..4:
                if not checks[i][x][y]:
                    result += boards[i][x][y]
    
    for n in nums:
        for i in players.toSeq.toSeq:
            if update(n,i):
                scores.add i.score*n
                players.excl i
    part 1: scores[0]
    part 2: scores[^1]