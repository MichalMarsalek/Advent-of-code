include aoc
import arraymancer

day 4:
    proc isWin(board_check: Tensor):bool =
        5 == board_check.sum(axis=0).max or
        5 == board_check.sum(axis=1).max
    var
     blocks = input.split "\n\n"
     nums = blocks[0].ints
     boards = blocks[1..^1].mapIt(it.intgrid.toTensor)
     boards_check = boards.mapIt(zeros[int](5,5))
     scores, wins:seq[int]
    
    for n in nums:
        for i in 0..<boards.len:
            boards_check[i] = (boards_check[i].astype(bool) or (boards[i] ==. n)).astype(int)
            if isWin(boards_check[i]) and (i notin wins):
                scores.add sum((1 -. boards_check[i]) *. boards[i]) * n
                wins.add i
    part 1: scores[0]
    part 2: scores[^1]