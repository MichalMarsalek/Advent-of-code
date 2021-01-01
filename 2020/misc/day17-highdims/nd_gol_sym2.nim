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

const DIM = 13
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

## mapping from sym points to sym neigbours with weights
var SYM_NEIGHBOURS_WEIGHTS = initTable[int, CountTable[int]]()

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
    
func binom2(n,k:int): int {.inline.} =
    ## Returns (n choose k) or 4 if it's unnecesarily big.
    if k == 0 or k == n:
        return 1
    if n <= 3:
        return n
    return 4

iterator genSplits(amount: int): (int, int, int) =
    ## Generates all 3-partitions of amount as well as total number of combinations.
    for L in 0..amount:
        for R in 0..amount-L:
            yield (L, R, binom2(amount, L)*binom2(amount-L, R))

func getSymNeighboursWeights(x: array[7, int]): CountTable[int] =
    ## Generates all neigbours of given cell with weights.
    ## Does so by considering how much of each occurence of 0s,...6s increases and decreases.
    for R0 in 0..x[0]:
        let m0 = 1 shl R0
        for L1,R1,m1 in gen_splits(x[1]):
            for L2,R2,m2 in gen_splits(x[2]):
                for L3,R3,m3 in gen_splits(x[3]):
                    for L4,R4,m4 in gen_splits(x[4]):
                        for L5,R5,m5 in gen_splits(x[5]):
                            for L6 in 0..x[6]:
                                let m6 = binom2(x[6], L6)
                                let newCell = [x[0]-R0+L1,
                                       x[1]-L1-R1+R0+L2,
                                       x[2]-L2-R2+R1+L3,
                                       x[3]-L3-R3+R2+L4,
                                       x[4]-L4-R4+R3+L5,
                                       x[5]-L5-R5+R4+L6,
                                       x[6]-L6+R5]
                                result.inc(newCell.pack, m0*m1*m2*m3*m4*m5*m6)
        

# Filling the precomp tables:
let time = cpuTime()
var cells_count = 0
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
                        var neighW = cell.getSymNeighboursWeights
                        SYM_NEIGHBOURS_WEIGHTS[cellPack] = neighW
                        #echo(cell, " ", neighW)
                        inc cells_count
                        neighbours_countW += neighW.len
echo "Precomputation time taken: ", cpuTime() - time
echo "Sym Cells: ", cells_count
echo "Average number of sym neighbours:", neighbours_countW div cells_count

# EVOLUTION
proc nxt(grid: seq[int]): seq[int] =
    ## Given a list of active cosets, returns a list of cosets in the next time step.
    var counting: CountTable[int] 
    for cell in grid:
        var sym = int(cell and CROP_SYM)
        for sym2 in SYM_NEIGHBOURS_WEIGHTS[sym].keys:
            for dxy in DXY:
                let cell2 = (cell + dxy) xor sym xor sym2
                let w = SYM_NEIGHBOURS_WEIGHTS[sym2][sym]
                counting.inc(cell2, 2*w)
        counting.inc(cell)
    for cell,val in counting:
        # active + 2 or 3 other active neigbours = active + 3 or 4 active neigbours = 0111 or 1001 = 7 or 9
        # not active + 3 other active neigbours = not active + 3 active neigbours   = 0110         = 6
        if (val == 6) or (val == 7) or (val == 9):
            result.add(cell)

proc weight(point:int):int =
    ## Returns a weight of a coset for final calculation.
    ## Weight is number of distinct permutations times 2^(number of nonzeroes).
    let sym = point.unpack2[2].unpack
    result = fac(k)
    for q in sym:
        result = result div fac(q)
    result = result shl (k-sym[0])
    

# Loads input
var grid = newSeq[int]()
var row = 0
let input = open("input.txt")
for line in input.lines:
  for i, col in line:
    if col == '#':
        grid.add(pack2(10+i, 10+row, k))
  inc row
input.close()


# Run computation
let time2 = cpuTime()
for round in 1..ROUNDS:
    grid = nxt(grid)

echo "Computation time taken: ", cpuTime() - time2
echo "Partial: ", grid.len
echo "Result: ", grid.toSeq.map(weight).sum
discard stdin.readLine