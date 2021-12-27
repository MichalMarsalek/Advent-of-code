include aoc
import heapqueue, intsets, times

type State = int
#0123456789012345678901234567890123456789012345678901234567890123
#33222111000                                                     


template unpackCounts(s:State):array[4,int] =
    let t = s shr 53
    [t mod 5, t div 5 mod 5, t div 25 mod 5, t div 125 mod 5]
template packCounts(a,b,c,d:int):State =
    (a + b*5 + c*25 + d*125) shl 53
template prepareDataVars() {.dirty.} =
    var counts {.inject.}: array[4,int]
    var rooms {.inject.}: array[4,array[4,int]]
    var hall {.inject.}: array[7,int]
    var ready {.inject.}: array[4,bool]
template extractData(s:State) {.dirty.} =
    counts = unpackCounts s
    rooms = [
        [(s shr 21) and 3, (s shr 23) and 3, (s shr 25) and 3, (s shr 27) and 3],
        [(s shr 29) and 3, (s shr 31) and 3, (s shr 33) and 3, (s shr 35) and 3],
        [(s shr 37) and 3, (s shr 39) and 3, (s shr 41) and 3, (s shr 43) and 3],
        [(s shr 45) and 3, (s shr 47) and 3, (s shr 49) and 3, (s shr 51) and 3],
    ]
    #empty in hall = 5
    hall = [s and 7, (s shr 3) and 7,(s shr 6) and 7,(s shr 9) and 7,(s shr 12) and 7,(s shr 15) and 7,(s shr 18) and 7]
    ready = [allIt(0..<counts[0], rooms[0][it] == 0),
                 allIt(0..<counts[1], rooms[1][it] == 1),
                 allIt(0..<counts[2], rooms[2][it] == 2),
                 allIt(0..<counts[3], rooms[3][it] == 3)]
const hallX = [1,2,4,6,8,10,11]
const roomAlignment = [4+3+2+1,3+2+1,2+1,1,0]
const winState = 5629487760098646893
template leftRoom(hall_i:int):int = hall_i - 2
template rightRoom(hall_i:int):int = hall_i - 1
template leftHall(room_i:int):int = room_i + 1
template rightHall(room_i:int):int = room_i + 2
const countUpdate = [(5^0) shl 53,(5^1) shl 53,(5^2) shl 53,(5^3) shl 53,(5^4) shl 53]
const costArray = [1,10,100,1000]
template moveFromRoomToHall(state: var State, room_i, hall_i:int) {.dirty.} =
    state -= countUpdate[room_i] # decrease target count
    state = state xor (rooms[room_i][counts[room_i]-1] xor hall[hall_i]) shl (3*hall_i) # set hall to the value
template moveFromHallToRoom(state: var State, hall_i, room_i:int) {.dirty.} =
    state += countUpdate[room_i] # increase target count
    state = state xor (5 xor hall[hall_i]) shl (3*hall_i) # set hall to 5
    state = state xor ((rooms[room_i][counts[room_i]] xor hall[hall_i]) shl (21 + room_i * 8 + 2*counts[room_i])) # set room to the value
template cost(i:int):int = costArray[i]


proc debugState(s:State) =
    var t = """
#############
#...........#
###.#.#.#.###
#.#.#.#.#  
#.#.#.#.#  
#.#.#.#.#  
#########"""
    prepareDataVars
    extractData s
    #dump rooms
    #dump counts
    #dump hall
    #dump ready
    func c(i:int):char =
        if i == 5: return '.'
        (i + 'A'.ord).chr
    for i in 0..3:
        for j in 0..<counts[i]:
            t[3+2*i + (5-j) * 14] = rooms[i][j].c
    for i in 0..6:
        t[hallX[i] + 14] = hall[i].c
    debugEcho t
    debugEcho ""

func getState(input:string, part:range[1..2]): State =
    var lines = input.splitLines
    for i in 0..6:
        if lines[1][hallX[i]] == '.':
            result = result xor 5 shl (3*i) # set hall to 5
        else:
            result = result xor (lines[1][hallX[i]].ord - 'A'.ord) shl (3*i) # set hall to 5
    if part == 1:
        lines = lines[2..3] & "  #A#B#C#D#" & "  #A#B#C#D#"
    else:
        lines = lines[2..2] & "  #D#C#B#A#" & "  #D#B#A#C#" & lines[3]
    var ccounts = [0,0,0,0]
    for x in 0..3:
        for y in 0..3:
            let val = lines[3-y][3+2*x]
            if val == '.':
                break
            result = result xor (val.ord - 'A'.ord) shl (21 + x * 8 + 2*y)
            ccounts[x] = y+1
    result = result xor packCounts(ccounts[0],ccounts[1],ccounts[2],ccounts[3])

iterator neighbours(state:State): (int,State) =
    prepareDataVars()
    extractData state
    block gen:
        for i in 0..6: #moves from hall to room
            if hall[i] != 5 and ready[hall[i]]: #if the hall slot is not empty and the target is ready
                if hall[i] >= i.rightRoom:      #if it needs to go to the right
                    if allIt(i+1..hall[i].leftHall, hall[it] == 5):
                        var copy = state
                        copy.moveFromHallToRoom(i, hall[i])
                        yield ((2* hall[i] + 7 - hallX[i] - counts[hall[i]])*hall[i].cost,copy)
                        break gen
                else:      #if it needs to go to the left
                    if allIt(hall[i].rightHall..i-1, hall[it] == 5):
                        var copy = state
                        copy.moveFromHallToRoom(i, hall[i])
                        yield ((hallX[i] - (2* hall[i]) + 1 - counts[hall[i]])*hall[i].cost,copy)
                        break gen
        
        for i in 0..3: #moves from room to hall
            if not ready[i]:
                var target = i.leftHall
                let val = rooms[i][counts[i]-1]
                while target >= 0 and hall[target] == 5: # moving left
                    var copy = state
                    copy.moveFromRoomToHall(i, target)
                    yield ((2 * i + 8 - hallX[target] - counts[i])*val.cost,copy)
                    dec target
                target = i.rightHall
                while target < 7 and hall[target] == 5: # moving right
                    var copy = state
                    copy.moveFromRoomToHall(i, target)
                    yield ((hallX[target] - (2 * i) + 2 - counts[i])*val.cost,copy)
                    inc target

func penalty(s:State):int =
    prepareDataVars()
    extractData s
    for i in 0..3:
        var correct = 0
        for j in 0..<counts[i]:
            if rooms[i][j] == i:
                if j == correct:
                    inc correct
                else:
                    result += (6-j)*i.cost #(2 + 4-j)*i.cost
            else:
                result += (4-j + 2*abs(i-rooms[i][j]))*rooms[i][j].cost
        result += roomAlignment[correct]*i.cost
    for i in 0..6:
        if hall[i]!=5:
            result += abs(2*hall[i] + 3 - hallX[i]) * hall[i].cost            

proc solve(initialState:State):int =
    var dist = {initialState: 0}.toTable
    var seen:IntSet
    var q = {0:initialState}.toHeapQueue
    var steps = 0
    while true:
        if q.len == 0:
            return -1
        let vv = q.pop
        let v = vv[1]
        if v == winState:
            return dist[v]
        seen.incl v
        for price,u in neighbours(v):
            if u notin seen:
                let newCost = dist[v] + price
                if newCost < dist.getOrDefault(u, int.high):                
                    dist[u] = newCost
                    q.push (dist[u]+u.penalty, u)

let input = readFile "inputs\\day23.in"
let timeStart = getTime()
let start1 = input.getState 1
#debugState start1
#dump start1.penalty
let start2 = input.getState 2
#dump start2.penalty
#debugState start1
dump solve start1
dump solve start2
dump getTime()-timeStart