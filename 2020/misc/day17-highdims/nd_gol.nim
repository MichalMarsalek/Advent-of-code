import sets, tables, intsets,  times, os, math, strutils

const DIM = 6
const k = DIM-2
const ROUNDS = 6
const REG_SIZE = 5
const MAX_VAL = 2^(REG_SIZE-1)

var grid = initIntSet()

# Inits neighbours
var neigbours: seq[int]
proc initNeigbours(base,depth: int) =
    if depth == 0: 
        neigbours.add(base)
    else:
        initNeigbours(base*2*MAX_VAL-1, depth-1)
        initNeigbours(base*2*MAX_VAL+0, depth-1)
        initNeigbours(base*2*MAX_VAL+1, depth-1)
initNeigbours(0,DIM)

# Calculates next iteration:
proc nxt(grid: IntSet): IntSet =
    var counting: CountTable[int]
    for x in grid:
        for dx in neigbours:
            counting.inc(x+dx)
    for x, count in counting:
        if count == 3 or (count == 4 and x in grid):
            result.incl(x)

func pack(cell: seq[int]):int =
    for c in cell:
        result = result*2*MAX_VAL + c

proc unpack(cell: int):seq[int] =
    result = newSeq[int](DIM)
    var cell = cell
    for i in 1..DIM:
        result[DIM-i] = cell mod (MAX_VAL*2)
        cell = cell div (MAX_VAL*2)

# Loads input
var row = 0
let input = open("input.txt")
for line in input.lines:
  for i, col in line:
    if col == '#':
      grid.incl(pack(@[row-MAX_VAL, i-MAX_VAL]))
  inc row
input.close()

# Run computation
let time = cpuTime()
for i in 1..ROUNDS:
    grid = nxt(grid) 

echo "Time taken: ", cpuTime() - time
echo "Result: ", grid.len
#for cell in grid:
#    echo cell.unpack

discard stdin.readLine