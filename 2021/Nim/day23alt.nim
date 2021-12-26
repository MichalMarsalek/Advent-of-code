include aoc
import heapqueue

type State = object
    hall: array[7,int]
    rooms: array[4,array[4,int]]
    correct: array[4,int]
    total: array[4,int]
    penalty: int
    #zobrhash: int
func `<`(a,b:(int,State)):bool =
    a[0] + a[1].penalty < b[0] + b[1].penalty
func hash(v:State):int =
    #v.zobrhash
    hash((v.hall,v.rooms))

const hallX = [1,2,4,6,8,10,11]
day 23:         
    func cost(i:int):int = 10^i
        
    proc debugState(s:State) =
        var t = """
#############
#...........#
###.#.#.#.###
  #.#.#.#.#  
  #.#.#.#.#  
  #.#.#.#.#  
  #########"""
        func c(i:int):char =
            if i == -1: return '.'
            (i + 'A'.ord).chr
        for i,room in s.rooms:
            for j in 0..<s.total[i]:
                t[3+2*i + (5-j) * 14] = room[j].c
        for i,e in s.hall:
            t[hallX[i] + 14] = e.c
        #echo s
        debugEcho t
        debugEcho ""

    func temp_penalty(s: State,deb=false): int =
        if deb: debugState s
        var icosts = [0,0,0,0]
        for i in 0..3:
            if s.total[i] != s.correct[i]:
                var allLowerCorrect = true
                for j in 0..<s.total[i]:
                    let val = s.rooms[i][j]
                    allLowerCorrect = allLowerCorrect and val == i
                    icosts[val] += abs(val - i) * 2 * val.cost # x alignment
                    if deb: dump ("x alignment", abs(val - i) * 2 * val.cost)
                    if i != val:                                                   # up movement
                        icosts[val] += (5 - j) * val.cost
                        if deb: dump ("up movement", (5 - j) * val.cost)
                    elif i == val and not allLowerCorrect:                         # get out of way movement
                        icosts[val] += (7-j) * val.cost
                        if deb: dump ("get out of way", (7-j) * val.cost)
            for j in s.correct[i]..3:
                icosts[i] += (3-j) * i.cost
                if deb: dump ("down movement", (3-j) * i.cost)
        for i in 0..6:
            if s.hall[i] != -1:
                icosts[s.hall[i]] += (1 + abs(3 + 2*s.hall[i] - hallX[i])) * s.hall[i].cost
                if deb: dump ("go home from hall", (1 + abs(3 + 2*s.hall[i] - hallX[i])) * s.hall[i].cost)
        if deb: dump icosts
        if deb: dump sum icosts
        sum icosts

    proc normalize(s: var State): int = 
        ## Move is normalized when it is not possible to make progress
        ## by moving something to a room
        var cont = true
        while cont:
            cont = false
            for i in 0..6: #moving from halls to home
                let target = s.hall[i]
                if target != -1 and s.correct[target] == s.total[target]:
                    if (s.hall[i] <= i - 2 and                       #it needs to go left
                        allIt((2+target)..i-1, s.hall[it] == -1)) or
                       (s.hall[i] > i - 2 and     
                        allIt(i+1..(1+target), s.hall[it] == -1)):   #it needs to go right
                        s.hall[i] = -1
                        s.rooms[target][s.total[target]] = target
                        inc s.total[target]
                        inc s.correct[target]
                        cont = true
                        result += (abs(3 + 2*target - hallX[i]) + 5 - s.total[target]) * target.cost
            if cont: continue
            for i in 0..3: #moving from room to home room
                if s.total[i] == 0: continue
                var target = s.rooms[i][s.total[i]-1]
                
                #dump (i, target)
                if target != i and s.total[target] == s.correct[target]:
                    if (target < i and                                 #it needs to go left
                        allIt((target+2)..(i+1), s.hall[it] == -1)) or
                       (target >= i and  
                        allIt((i+2)..(target+1), s.hall[it] == -1)):   #it needs to go right
                        dec s.total[i]
                        if allIt(0..<s.total[i], it == i):
                            s.correct[i] = s.total[i]
                        s.rooms[target][s.total[target]] = s.rooms[i][s.total[i]]
                        inc s.total[target]
                        inc s.correct[target]
                        cont = true
                        result += (abs(i-target)*2 + 4 - s.total[i] + 5 - s.total[target]) * target.cost
                #debugState s
        s.penalty = temp_penalty s

    func getState(input:string, part:range[1..2]): State =
        result.hall.fill(-1)
        var lines = input.splitLines
        for i,e in lines[1]:
            if 'A'<=e and e<='D':
                result.hall[i div 2] = e.ord - 'A'.ord
        if part == 1:
            lines = lines[2..3] & "  #A#B#C#D#" & "  #A#B#C#D#"
        else:
            lines = lines[2..2] & "  #D#C#B#A#" & "  #D#B#A#C#" & lines[3]
        for y in 0..3:
            let h = lines[3-y]
            for x in 0..3:
                result.rooms[x][y] = h[3+2*x].ord - 'A'.ord
                if h[3+2*x] != '.':
                    inc result.total[x]
                if result.correct[x] == y and result.rooms[x][y] == x:
                    inc result.correct[x]
    
    iterator neighbours(s:State): (int,State)=
        ## Generates tries to move from the rooms to the halls
        template moveUp() {.dirty.} =
            var copy = s
            var price = 0
            dec copy.total[i]
            copy.hall[target] = copy.rooms[i][copy.total[i]]
            price += (abs(3 + 2*i - hallX[target]) + 4 - copy.total[i]) *
                     copy.hall[target].cost
            price += normalize copy
            yield (price, copy)
        
        for i in 0..3:
            if s.total[i] == s.correct[i]: continue
            var target = i+1
            while target >= 0 and s.hall[target] == -1:
                moveUp()
                dec target
            target = i+2
            while target < 7 and s.hall[target] == -1:
                moveUp()
                inc target
    
    
    func isWin(state:State):bool =
        state.correct.allIt it==4
    
    #func penalty(v:State): int =
    #    0
    
    
    
    proc solve(initialState:State):int =
        var dist = {initialState: 0}.toTable
        var seen = [initialState].toHashSet
        var q = {0:initialState}.toHeapQueue
        var steps = 0
        while true:
            inc steps
            if q.len == 0:
                return -1
            let vv = q.pop
            let v = vv[1]
            if v.isWin:
                dump steps
                return dist[v]
            seen.incl v
            for price,u in neighbours(v):
                if u notin seen:
                    let newCost = dist[v] + price
                    if newCost < dist.getOrDefault(u, int.high):                
                        dist[u] = newCost
                        q.push (dist[u], u)
    var start1 = input.getState 1
    dump start1.temp_penalty
    var start2 = input.getState 2
    dump start2.temp_penalty
    #dump start2.temp_penalty
    #debugState start1
    #discard normalize start1
    #debugState start1
    #for x in neighbours start1:
    #    echo "n"
    #    debugState x[1]
    #    dump x[1].solve(false,false)
    #    dump x[1].penalty
    part 1: solve start1
    part 2: solve start2