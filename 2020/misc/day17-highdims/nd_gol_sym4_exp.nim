import sets, tables, intsets,  times, os, strutils, sequtils, math
import bigints

const ROUNDS = 6
var DIM, k: int
type Sym = int
type Stack = HashSet[Sym]
type Grid = array[20, array[20, Stack]]

# packing/unpacking
func pack(sym: array[7, int]): Sym =
    for i in 0..6:
        result = (result shl 8) xor sym[6-i]

func unpack(packed:Sym): array[7, int] =
    var packed = packed
    for i in 0..6:
        result[i] = int(packed and 0xff)
        packed = packed shr 8

# Neigbours calculations   
func binom2(n,k:int): int {.inline.} =
    ## Returns (n choose k) or 4 if it's unnecesarily big.
    if k > n:
        return 0
    if k == 0 or k == n:
        return 1
    if n <= 3:
        return n
    return 4
    
func neg(a:int):int {.inline.} =
    ## Returns the negative part of a number.
    min(a,0)
func pos(a:int):int {.inline.} =
    ## Returns the positive part of a number.
    max(a,0)

proc getNeighbours(xx: Sym): seq[(Sym, int)] =
    ## Generates all neigbours of given cell with weights.
    ## Does so by considering how much of each occurence of 0s,...6s increases and decreases.
    ## L[i] ... how many i's changed to i-1
    ## R[i] ... how many i's changed to i+1
    ## s[i] ... flow from i's to i+1's, that is s[i] = R[i]-L[i+1]
    ## quantities s[i] identify each neigbour uniqualy,
    ## but the transformation can happen in many ways depending on L[i] and R[i]
    let x = xx.unpack
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
                            var ways:int
                            # If it's a big number (> 4) I don't need to know how large it is
                            block slow: 
                                for R0 in pos(s0)..x[0]:
                                    let L1 = R0 - s0
                                    let m0 = 1 shl L1
                                    for R1 in pos(s1)..x[1]-L1:
                                        let L2 = R1 - s1
                                        let m1 = binom2(newCell[1], R0) * binom2(newCell[1]-R0, L2)
                                        for R2 in pos(s2)..x[2]-L2:
                                            let L3 = R2 - s2
                                            let m2 = binom2(newCell[2], R1) * binom2(newCell[2]-R1, L3)
                                            for R3 in pos(s3)..x[3]-L3:
                                                let L4 = R3 - s3                                                    
                                                let m3 = binom2(newCell[3], R2) * binom2(newCell[3]-R2, L4)
                                                for R4 in pos(s4)..x[4]-L4:
                                                    let L5 = R4 - s4
                                                    let m4 = binom2(newCell[4], R3) * binom2(newCell[4]-R3, L5)
                                                    let m5 = binom2(newCell[5], R4)
                                                    ways  += m0*m1*m2*m3*m4*m5
                                                    if ways >= 4:
                                                        break slow                                                          
                                            
                            result.add((newCell.pack,ways))

## Memo table
var STACK_NEIGBOURS_MEMO: Table[Stack, CountTable[Sym]]

proc getStackNeighbours(stack: Stack): CountTable[Sym] =
    ## Returns union of neigbours of points in stack,
    ## along with sum of respective weights.
    if stack in STACK_NEIGBOURS_MEMO:
        return STACK_NEIGBOURS_MEMO[stack]
    for a in stack:
        for (b, weight) in getNeighbours(a):
            result.inc(b, weight)
    STACK_NEIGBOURS_MEMO[stack] = result

# Time steps
proc nxt(grid: Grid, round: int): Grid =
    ## Given current grid, return grid state in next time step.
    var counting: array[20, array[20, CountTable[Sym]]]
    for x in 7-round..12+round:
        for y in 7-round..12+round:
            for sym, weight in grid[x][y].getStackNeighbours:
                for dx in -1..1:
                    for dy in -1..1:
                        counting[x+dx][y+dy].inc(sym, weight)
    
    for x in 6-round..13+round:
        for y in 6-round..13+round:
            for sym, value in counting[x][y]:
                if value == 3 or (value == 4 and sym in grid[x][y]):
                    result[x][y].incl(sym)

# Final result calculation
# Only relevant as long as it fits in 64 bits (d <= 25)

func factorial(n:int):BigInt =
    ## Returns n!
    result = initBigInt(1)
    for i in 1..n:
        result *= i.int32

proc weight(a:Sym):BigInt =
    ## Returns a weight of a coset for final calculation.
    ## Weight is number of distinct permutations times 2^(number of nonzeroes).
    
    let sym = a.unpack
    result = factorial(k)
    for q in sym:
        result = result div factorial(q)
    result = result shl (k-sym[0])

proc finalAnswer(grid:Grid):BigInt =
    for x in 0..<20:
        for y in 0..<20:
            for sym in grid[x][y]:
                result += sym.weight

func countCosets(grid:Grid): int =
    for x in 0..<20:
        for y in 0..<20:
            result += grid[x][y].len

func countAllCosets(k: int): int =
    for a0 in 0..k:
        for a1 in 0..k-a0:
            for a2 in 0..k-a1-a0:
                for a3 in 0..k-a2-a1-a0:
                    for a4 in 0..k-a3-a2-a1-a0:
                        result += k-a4-a3-a2-a1-a0 + 1

# Benchmarking different dimensions
for DIM in countup(2,20):
    k = DIM-2
    STACK_NEIGBOURS_MEMO = initTable[Stack, CountTable[Sym]]()

    # Loads input
    var grid: Grid
    var y = 0
    let input = open("input.txt")
    for line in input.lines:
      for x, character in line:
        if character == '#':
            grid[6+x][6+y].incl(k.Sym)
      inc y
    input.close()

    # Run computation
    let time = cpuTime()
    echo "Dim: ", DIM
    for round in 1..ROUNDS:
        grid = grid.nxt(round)
        echo "Round ", round, " coset count: ", grid.countCosets
    
    echo "Time: ", cpuTime() - time
    #echo "Unique stacks: ", STACK_NEIGBOURS_MEMO.len
    #echo "Unique cosets: ", grid.countCosets
    echo "Result: ", grid.finalAnswer
    echo "Total sym cosets: ", countAllCosets(k)
    echo ""

discard stdin.readLine