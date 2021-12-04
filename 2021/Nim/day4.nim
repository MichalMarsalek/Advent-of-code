include aoc

day 4:
    proc empty(x:auto):auto =
        mapIt(0..<5, @[false,false,false,false,false])
    
    proc isWin(board_check: seq[seq[bool]]):bool =
        for i in 0..<5:
            if allIt(0..<5, board_check[i][it]):return true
            if allIt(0..<5, board_check[it][i]):return true
    
    proc score(board_check: seq[seq[bool]], board: seq[seq[int]]):int =
        for x in 0..<5:
            for y in 0..<5:
                if not board_check[x][y]:
                    result += board[x][y]
    
    proc newNumber(board_check: seq[seq[bool]], board: seq[seq[int]], n:int):seq[seq[bool]] =
        result = empty(0)
        for x in 0..<5:
            for y in 0..<5:
                result[x][y] = board[x][y] == n or board_check[x][y]
    
    var
     blocks = input.split "\n\n"
     nums = blocks[0].ints
     boards = blocks[1..^1].map intgrid
     boards_check = boards.map empty
     scores, wins:seq[int]
    
    for n in nums:
        for i in 0..<boards.len:
            var temp = newNumber(boards_check[i], boards[i], n)
            boards_check[i] = temp
            if isWin(boards_check[i]) and (i notin wins):
                scores.add score(boards_check[i], boards[i])*n
                wins.add i
    part 1: scores[0]
    part 2: scores[^1]