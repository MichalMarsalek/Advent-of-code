import sets, tables, intsets,  times, os, strutils, sequtils, math

## Each point is represented as a triple:
## (x, y, sym)
## where x, y are the nonsymmetric dimensions and sym are the rest d-2 symmetric ones.
## These symmetric components are represented as a 7-tuple,
## each position storing the amount of 0s, 1s, ..., 6s in the coordinate.
## This 7-tuple is further packed into a single int64 (each component = 1 byte).
##
## Troughout the calculation, we only track which cosets are active.
## Since there aren't many different sets of active sym components,
## we memoize effects of each such set.
##
## Active cosets are stored in grid:array[20, array[20, seq[int]]], where
## grid[x][y] holds all symmetric components of points with given x,y.
## 
## Since there seem to be a small fixed amount of unique sets of active cosets,
## we memoize their effects.
## 
## In the end, we weight each active coset by its size.

const ROUNDS = 6
var DIM, k: int
type Sym = uint64
type Stack = HashSet[Sym]
type Grid = array[20, array[20, Stack]]

# packing/unpacking
func pack(sym: array[7, int]): Sym =
    for i in 0..6:
        result = (result shl 8) xor sym[6-i].uint64

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

func getNeighbours(xx: Sym): seq[(Sym, int)] =
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
                            # This should be optimized and calculated without iteration
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

func factorial(n:int):(uint64, int) =
    ## Returns (o mod 2^64, e) where o is odd and n! = o × 2^e
    var o: uint64 = 1
    var e: int = 0
    for i in 1..n:
        var j = i.uint64
        while j mod 2 == 0:
            j = j shr 1
            e += 1
        o *= j
    return (o,e)

func inverse(x:uint64):uint64 =
    ## Given odd x returns x^(-1) mod 2^64.
    result = x
    for _ in 1..5:
        result *= (2 - result*x)

proc weight(a:Sym):uint64 =
    ## Returns a weight of a coset for final calculation.
    ## Weight is number of distinct permutations times 2^(number of nonzeroes).
    ## Calculation is done mod 2^64 (except for division by 2 of course - powers
    ## of two are handled separately.
    
    let sym = a.unpack
    var (o,e) = factorial(k)
    for q in sym:
        let (o2, e2) = factorial(q)
        o *= inverse(o2)
        e -= e2
    result = o shl (e + k-sym[0])

# Benchmarking different dimensions
for DIM in 3..40:
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
    for round in 1..ROUNDS:
        grid = grid.nxt(round)

    echo "Dim: ", DIM
    echo "Computation time taken: ", cpuTime() - time
    echo "Unique stacks: ", STACK_NEIGBOURS_MEMO.len
    var cosets: int
    if DIM <= 25:
        var final_result: uint64
        for x in 0..<20:
            for y in 0..<20:
                final_result += grid[x][y].toSeq.map(weight).sum
                cosets += grid[x][y].len
        echo "Result: ", final_result
        echo "Unique cosets: ", cosets
    else:
        echo "Final result doesn't fit into 64 bits."
        
discard stdin.readLine