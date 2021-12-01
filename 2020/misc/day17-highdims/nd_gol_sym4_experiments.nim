import sets, tables, intsets,  times, os, strutils, sequtils, math

const ROUNDS = 6
const DIM = 10
const k = DIM-2

type CosetRange = range[0..3002]
type Coset = int32
#type SymCosetSet = array[47,int64] 
type SymCosetSet = set[CosetRange] 
type SymNeighbourhood = array[1..4,SymCosetSet]
type Grid = array[20, array[20, SymCosetSet]]


func add(a: var SymNeighbourhood, b: SymNeighbourhood): SymNeighbourhood =
    let b34 = b[3] + b[4]
    let b234 = b[2] + b34
    let b1234 = b[1] + b234
    result[4] = a[4] + (a[3] * b1234) + (a[2] * b234) + (a[1] * b34) + b[4]
    result[3] = a[3] - b1234 + (a[2] * b[1]) + (a[1] * b[2])
    result[2] = a[2] - b1234 + (a[1] * b[1])
    result[1] = a[1] - b1234 + (({CosetRange(0)..CosetRange(3002)}-a[1]-a[2]-a[3]-a[4]))*b[1]
   
func neg(a:int):int = min(a,0)
func pos(a:int):int = max(a,0)
func binom2(n,k:int): int {.inline.} =
    ## Returns (n choose k) or 4 if it's unnecesarily big.
    if k > n:
        return 0
    if k == 0 or k == n:
        return 1
    if n <= 3:
        return n
    return 4

func pack(sym: array[6, int]): int32 =
    for s in sym:
        result = int32(result shl 4) xor s.int32    

template forallSyms(code:untyped) {.dirty.} =
    var i:int
    for a6 in 0..k:
        for a5 in 0..k-a6:
            for a4 in 0..k-a6-a5:
                for a3 in 0..k-a6-a5-a4:
                    for a2 in 0..k-a6-a5-a4-a3:
                        for a1 in 0..k-a6-a5-a4-a3-a2:
                            let a0 = k-a6-a5-a4-a3-a2-a1
                            let cell = [a0,a1,a2,a3,a4,a5]
                            code
                            inc i
    
func COMPILE_COSET_LIST(): array[3003, Coset] =
    forallSyms:
        result[i] = cell.pack     
const ID2COSET = COMPILE_COSET_LIST()

func COMPILE_COSET_LIST2(): Table[Coset, CosetRange] =
    forallSyms:
        result[cell.pack] = i        
const COSET2ID = COMPILE_COSET_LIST2()


func COMPILE_SYM_NEIGHBOURS(): array[3003, SymNeighbourhood] =
    forallSyms:
        for s0 in -a1..a0:
            for s1 in -a2..a1+neg(s0):
                for s2 in -a3..a2+neg(s1):
                    for s3 in -a4..a3+neg(s2):
                        for s4 in -a5..a4+neg(s3):
                            for s5 in 0..a5+neg(s4):
                                let newCell = [a0 - s0,
                                        a1 + s0 - s1,
                                        a2 + s1 - s2,
                                        a3 + s2 - s3,
                                        a4 + s3 - s4,
                                        a5 + s4 - s5]
                                var ways:int
                                # If it's a big number (> 4) I don't need to know how large it is
                                block slow: 
                                    for R0 in pos(s0)..a0:
                                        let L1 = R0 - s0
                                        let m0 = 1 shl L1
                                        for R1 in pos(s1)..a1-L1:
                                            let L2 = R1 - s1
                                            let m1 = binom2(newCell[1], R0) * binom2(newCell[1]-R0, L2)
                                            for R2 in pos(s2)..a2-L2:
                                                let L3 = R2 - s2
                                                let m2 = binom2(newCell[2], R1) * binom2(newCell[2]-R1, L3)
                                                for R3 in pos(s3)..a3-L3:
                                                    let L4 = R3 - s3                                                    
                                                    let m3 = binom2(newCell[3], R2) * binom2(newCell[3]-R2, L4)
                                                    for R4 in pos(s4)..a4-L4:
                                                        let L5 = R4 - s4
                                                        let m4 = binom2(newCell[4], R3) * binom2(newCell[4]-R3, L5)
                                                        let m5 = binom2(newCell[5], R4)
                                                        ways  += m0*m1*m2*m3*m4*m5
                                                        if ways >= 4:
                                                            break slow
                                if ways > 4:
                                    ways = 4
                                result[i][ways].incl(COSET2ID[newCell.pack])
var time = getTime()
let SYM_NEIGHBOURS = COMPILE_SYM_NEIGHBOURS()
echo getTime()-time

var STACK_NEIGBOURS_MEMO: Table[SymCosetSet, SymNeighbourhood]
proc getStackNeighbours(stack: SymCosetSet): SymNeighbourhood =
    ## Returns union of neigbours of points in stack,
    ## along with sum of respective weights.
    if stack in STACK_NEIGBOURS_MEMO:
        return STACK_NEIGBOURS_MEMO[stack]
    for a in stack:
        result = result.add(SYM_NEIGHBOURS[a])
    STACK_NEIGBOURS_MEMO[stack] = result

proc nxt(grid: Grid, round: int): Grid =
    ## Given current grid, return grid state in next time step.
    var counting: array[20, array[20, SymNeighbourhood]]
    for x in 7-round..12+round:
        for y in 7-round..12+round:
            for dx in -1..1:
                for dy in -1..1:
                    counting[x+dx][y+dy] = counting[x+dx][y+dy].add(grid[x][y].getStackNeighbours)
    
    for x in 6-round..13+round:
        for y in 6-round..13+round:
            result[x][y] = counting[x][y][3] + counting[x][y][2] * grid[x][y]

# Loads input
var grid: Grid
var y = 0
let input = open("input.txt")
for line in input.lines:
  for x, character in line:
    if character == '#':
        grid[6+x][6+y].incl(0)
  inc y
input.close()

# Run computation
var time2 = getTime()
for round in 1..ROUNDS:
    grid = grid.nxt(round)
echo getTime()-time2