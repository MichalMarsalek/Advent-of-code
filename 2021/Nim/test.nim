include aoc
import macros

macro importModules(names: static[openarray[string]]): untyped =
    nnkImportStmt.newTree(names.mapIt(newIdentNode it))

importModules(["day1", "day2"])
for k in SOLUTIONS.keys.toSeq.sorted:
    run(k)