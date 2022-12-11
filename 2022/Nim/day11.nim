include aoc

day 11:
    type Monkey = object
        items: Deque[int]
        operand: int
        op: char
        test: int
        ifTrue: int
        ifFalse: int
        totalInspected: int
    var monkeys = collect:
        for group in input.split "\n\n":
            let lines = group.splitLines
            Monkey(
                items: lines[1].ints.toDeque,
                op: if '*' in lines[2]: '*' else: '+',
                operand: (lines[2].ints & -1)[0],
                test: lines[3].ints1,
                ifTrue: lines[4].ints1,
                ifFalse: lines[5].ints1,
            )
    proc simulate(monkeys: seq[Monkey], divBy: int, rounds: int): int =
        var monkeys = deepCopy monkeys
        let wrap = prod monkeys.mapIt it.test
        for round in 1..rounds:
            for monkey in mitems monkeys:
                while monkey.items.len > 0:
                    inc monkey.totalInspected
                    var x = monkey.items.popFirst
                    var operand = if monkey.operand == -1: x else: monkey.operand
                    if monkey.op == '+': x += operand
                    else: x *= operand
                    x = x div divBy
                    if divBy == 1:
                        x = x mod wrap
                    if x mod monkey.test == 0:
                        monkeys[monkey.ifTrue].items.addLast x
                    else:
                        monkeys[monkey.ifFalse].items.addLast x
        let scores = monkeys.mapIt(it.totalInspected).sorted
        scores[^1] * scores[^2]
    part 1: simulate(monkeys, 3, 20)
    part 2: simulate(monkeys, 1, 10000)
