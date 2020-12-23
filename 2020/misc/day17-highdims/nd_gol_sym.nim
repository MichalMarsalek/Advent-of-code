import sets, tables, intsets,  times, os, math, strutils, sequtils

## Each point is represented as a triple:
## (x, y, sym)
## where x, y are the nonsymmetric dimensions and sym are the rest d-2 symmetric ones.
## These symmetric components are represented as a 7-tuple,
## each position storing the amount of 0s, 1s, ..., 6s in the coordinate.
## So, every point is represented by 9 values, these are further packed into a single int64.
## 
## In the precomputation phase we calculate neigbours of all cells that might get activated (restricted on the symmetric component).
##
## Troughout the calculation, we only track which cosets are active.
## In the end, we weight each active cosets by its size.

const DIM = 12
const k = DIM-2
const ROUNDS = 6
const CROP_SYM = 0b11111111111111111111111111111111111

# PRECOMPUTATION
## differences in the nonsymmetric dimensions
const DXY = [-1 * (1 shl 50) - 1 * (1 shl 35),
             -1 * (1 shl 50) + 0 * (1 shl 35),
             -1 * (1 shl 50) + 1 * (1 shl 35),
              0 * (1 shl 50) - 1 * (1 shl 35),
              0 * (1 shl 50) + 0 * (1 shl 35),
              0 * (1 shl 50) + 1 * (1 shl 35),
              1 * (1 shl 50) - 1 * (1 shl 35),
              1 * (1 shl 50) + 0 * (1 shl 35),
              1 * (1 shl 50) + 1 * (1 shl 35)]

## mapping from sym points to sym neigbours
var SYM_NEIGHBOURS_WEIGHTS = initTable[int, seq[(int, int)]]()
var SYM_NEIGHBOURS = initTable[int, seq[int]]()

## packing/unpacking, not used in the main computation, mostly for precomp and debugging.
func pack(sym: array[7, int]): int =
    for i in 0..6:
        result = (result shl 5) xor sym[6-i]

func unpack(packed:int): array[7, int] =
    var packed = packed
    for i in 0..6:
        result[i] = packed and 0b11111
        packed = packed shr 5

func pack2(x,y:int, sym:int): int =
    (((x shl 15) xor y) shl (35)) xor sym

func unpack2(packed:int): (int, int, int) =
    let sym = packed and CROP_SYM
    let y = (packed shr 35) and 0b11111
    let x = (packed shr 50)
    return (x, y, sym.int)

iterator genSplits(amount: int): (int, int, int) =
    ## Generates all 3-partitions of amount as well as total number of combinations.
    for L in 0..amount:
        for R in 0..amount-L:
            yield (L, R, binom(amount, L)*binom(amount-L, R))

func getSymNeighboursWeights(x: array[7, int]): seq[(int, int)] =
    ## Generates all neigbours of given cell with weights.
    ## Does so by considering how much of each occurence of 0s,...6s increases and decreases.
    for L0,R0,m0 in gen_splits(x[0]):
        for L1,R1,m1 in gen_splits(x[1]):
            for L2,R2,m2 in gen_splits(x[2]):
                for L3,R3,m3 in gen_splits(x[3]):
                    for L4,R4,m4 in gen_splits(x[4]):
                        for L5,R5,m5 in gen_splits(x[5]):
                            for L6 in 0..x[6]:
                                let m6 = binom(x[6], L6)
                                let newCell = [x[0]-L0-R0+L1,
                                       x[1]-L1-R1+R0+L0+L2,
                                       x[2]-L2-R2+R1+L3,
                                       x[3]-L3-R3+R2+L4,
                                       x[4]-L4-R4+R3+L5,
                                       x[5]-L5-R5+R4+L6,
                                       x[6]-L6+R5]
                                result.add((newCell.pack, m0*m1*m2*m3*m4*m5*m6))

func neg(a:int):int {.inline.}=
    ## Returns the negative part of a number.
    min(a,0)

func getSymNeighbours(x: array[7, int]): seq[int] =
    ## Generates all neigbours of given point.
    ## Does so by considering the flow between 0s -> 1s, 1s -> 2s etc.
    for s0 in -x[1]..x[0]:
        for s1 in -x[2]..x[1]+neg(s0):
            for s2 in -x[3]..x[2]+neg(s1):
                for s3 in -x[4]..x[3]+neg(s2):
                    for s4 in -x[5]..x[4]+neg(s3):
                        for s5 in 0..x[5]+neg(s4):
                            let newCell = [x[0] - s0,
                                    x[1] + s0 - s1,
                                    x[2] + s1 - s2,
                                    x[3] + s2 - s3,
                                    x[4] + s3 - s4,
                                    x[5] + s4 - s5,
                                    + s5]
                            result.add(newCell.pack)

# Filling the precomp tables:
let time = cpuTime()
var cells_count = 0
var neighbours_count = 0
var neighbours_countW = 0
for A0 in 0..k:
    for A1 in 0..k-A0:
        for A2 in 0..k-A0-A1:
            for A3 in 0..k-A0-A1-A2:
                for A4 in 0..k-A0-A1-A2-A3:
                    for A5 in 0..k-A0-A1-A2-A3-A4:
                        let A6 = k-A0-A1-A2-A3-A4-A5
                        var cell = [A0, A1, A2, A3, A4, A5, A6]
                        var cellPack = cell.pack
                        var neigh = cell.getSymNeighbours
                        var neighW = cell.getSymNeighboursWeights
                        SYM_NEIGHBOURS_WEIGHTS[cellPack] = neighW
                        SYM_NEIGHBOURS[cellPack] = neigh
                        inc cells_count
                        neighbours_count += neigh.len
                        neighbours_countW += neighW.len
echo "Precomputation time taken: ", cpuTime() - time
echo "Sym Cells: ", cells_count
echo "Average number of sym neighbours:", neighbours_countW div cells_count
echo "Average number of pure sym neighbours:", neighbours_count div cells_count

# EVOLUTION
proc nxt(grid: IntSet, round:int): IntSet =
    ## Given a set of active cosets, returns a set of cosets in the next time step.
    var counting: CountTable[int] 
    var test = 0
    for cell in grid:
        var sym = int(cell and CROP_SYM)
        for dxy in DXY:
            for sym2 in SYM_NEIGHBOURS[sym]:
                counting.inc((cell + dxy) xor sym xor sym2)
                test += 1
    for cell,val in counting:
        if val <= 4:
            var neighbours_count = 0
            var sym = int(cell and CROP_SYM)
            block explore:
                for dxy in DXY:
                    for sym2, amount in SYM_NEIGHBOURS_WEIGHTS[sym].items:
                        let cell2 = (cell + dxy) xor sym xor sym2
                        if cell2 in grid:
                            neighbours_count += amount
                        if neighbours_count > 4:
                            break explore
            if neighbours_count == 3 or (neighbours_count == 4 and cell in grid):
                result.incl(cell)

proc weight(point:int):int =
    ## Returns a weight of a coset for final calculation.
    ## Weight is number of distinct permutations times 2^(number of nonzeroes).
    var sym = point.unpack2[2].unpack
    result = fac(k)
    for q in sym:
        result = result div fac(q)
    result = result shl (k-sym[0])
    

# Loads input
var grid = initIntSet()
var row = 0
let input = open("input.txt")
for line in input.lines:
  for i, col in line:
    if col == '#':
        grid.incl(pack2(10+i, 10+row, k))
  inc row
input.close()


# Run computation
let time2 = cpuTime()
for round in 1..ROUNDS:
    grid = nxt(grid, round)

echo "Computation time taken: ", cpuTime() - time2
echo "Partial: ", grid.len
echo "Result: ", grid.toSeq.map(weight).sum
discard stdin.readLine