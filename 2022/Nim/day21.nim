include aoc

day 21:
    type Expr = object
        case isLeaf: bool
            of true:
                value: float
            of false:
                op: string
                left: string
                right: string
    var monkeys: Table[string, Expr]
    proc eval(expr: Expr): float =
        if expr.isLeaf: return expr.value
        return ops[expr.op](monkeys[expr.left].eval, monkeys[expr.right].eval)

    for line in lines:
        var a, b, c, op: string
        var val: int
        if line.scanf("$w: $i", a, val):
            monkeys[a] = Expr(isLeaf: true, value: float val)
        elif line.scanf("$w: $w $* $w", a, b, op, c):
            monkeys[a] = Expr(isLeaf: false, op: op, left: b, right: c)
    part 1: monkeys["root"].eval.int
    part 2:
        monkeys["root"].op = "-"
        proc f(x: float): float =
            monkeys["humn"].value = x
            monkeys["root"].eval
        binarySearch(f).int
