include aoc
import heapqueue

type State = array[4,array[4,Point]]
func `<`(a,b:(int,State)):bool =
    a[0] < b[0]

day 23:
    proc normalize(a: var State) =
        for i in 0..3:
            sort a[i]
    
    func cost(i:int):int = 10^i
    func goalX(i:int):int = (3 + i * 2)
    
    func contains(v:State, p:Point): bool =
        for group in v:
            for emp in group:
                if emp == p: return true
    
    func getState(input:string, part:range[1..2]): State =
        var lines = input.splitLines
        if part == 1:
            lines = lines[0..3] & "  #A#B#C#D#" & "  #A#B#C#D#"
        else:
            lines = lines[0..2] & "  #D#C#B#A#" & "  #D#B#A#C#" & lines[3]
        var seenType = [0,0,0,0]
        for y,row in lines:            
            for x,c in row:
                if 'A' <= c and c <= 'D':
                    let o = c.ord - 'A'.ord
                    result[o][seenType[o]] = (x,y)
                    seenType[o] += 1
        normalize result
    
    func isWin(state:State):bool =
        for i in 0..3:
            if state[i] != {i.goalX:2, i.goalX:3, i.goalX:4, i.goalX:5}:
                return false
        return true
    
    func countCorrect(state:State,i:int):int =
        card({i.goalX:2, i.goalX:3, i.goalX:4, i.goalX:5}.toHashSet * state[i].toHashSet)
    func countCorrect2(state:State,i:int):int =
        let x = i.goalX
        for y in countdown(5,2):
            if (x,y) in state[i]:
                inc result
            else:
                return
    
    func penalty(v:State): int =
        for i,group in v:
            var pl = 0
            for j,p in group:
                if p.x != i.goalX:
                    result += (abs(p.x - i.goalX) + p.y - 1) * i.cost
                    #debugecho ("shift+up", i,p, (abs(p.x - i.goalX) + p.y - 1) * i.cost)
                    result += (4-v.countCorrect2(i)-pl) * i.cost
                    #debugecho ("down    ", i,p, (4-v.countCorrect2(i)-pl) * i.cost)
                    inc pl                        
                elif 6-v.countCorrect2(i) > p.y:
                    result += (p.y+7-pl) * i.cost
                    inc pl
                    discard
                    #debugecho ("up+down ", i,p, (p.y+7-pl) * i.cost)
                #debugecho ""
                    
            
    
    func countAll(state:State,x:int):int =
        for group in state:
            for amp in group:
                if amp.x == x: inc result
    
    iterator trackMovement(a,b:int):int =
        var a = a
        while a != b:
            yield a
            a += sgn(b-a)
        yield a
    
    iterator moveOut(v:State, i,j:int): (int,State) =
        const stops = [1,2,4,6,8,10,11]
        var s = v[i][j].x
        while (s-1, 1) notin v:
            s -= 1
            if s < 1: break
            if s notin stops: continue
            var copy = v
            copy[i][j] = (s,1)
            normalize copy
            yield ((v[i][j].x-s + v[i][j].y - 1)*i.cost, copy)
        s = v[i][j].x
        while (s+1, 1) notin v:
            s += 1
            if s > 11: break
            if s notin stops: continue
            var copy = v
            copy[i][j] = (s,1)
            normalize copy
            yield ((s-v[i][j].x + v[i][j].y - 1)*i.cost, copy)
    
    proc debugState(state:State) =
        var t = """
#############
#...........#
###.#.#.#.###
  #.#.#.#.#  
  #.#.#.#.#  
  #.#.#.#.#  
  #########"""
        for c, g in state:
            for p in g:
                t[p.x + p.y * 14] = (c + 'A'.ord).chr
        echo t
        echo ""
    
    iterator moveIn(v:State, i,j:int): (int, State) =
        block all:
            if v.countCorrect(i) == v.countAll(i.goalX):
                for x in trackMovement(v[i][j].x + sgn(i.goalX-v[i][j].x), i.goalX):
                    if (x, 1) in v:
                        break all
                var copy = v
                copy[i][j] = (i.goalX, 5-v.countCorrect(i))
                normalize copy
                yield ((abs(v[i][j].x - i.goalX) + 4 - v.countCorrect(i)) * i.cost, copy)        
    
    
    iterator neighbours(v:State): (int,State)=
        var needToMoveOut = true
        for i in 0..3:
            for j in 0..3:
                if v[i][j].y == 1:
                    for x in moveIn(v, i, j):
                        yield x
                        needToMoveOut = false
        if needToMoveOut:
            for i in 0..3:
                for j in 0..3:
                    if v[i][j].x in [3,5,7,9]:
                        if anyIt(2..<v[i][j].y, (v[i][j].x, it) in v): continue
                        if v[i][j].x != i.goalX or v.countCorrect(i) != v.countAll(i.goalX):
                            for x in moveOut(v, i, j):
                                yield x
    
    proc solve(initialState:State):int =
        var dist = {initialState: 0}.toTable
        var seen = [initialState].toHashSet
        var q = {0:initialState}.toHeapQueue
        var steps = 0
        while true:
            inc steps
            let vv = q.pop
            let v = vv[1]
            #dump (vv[0], dist[v])
            if v.isWin:
                dump steps
                return dist[v]
            seen.incl v
            for price,u in neighbours(v):
                if u notin seen:
                    let newCost = dist[v] + price
                    if newCost < dist.getOrDefault(u, 2^60):                
                        dist[u] = newCost
                        q.push (dist[u] + u.penalty, u)
    echo penalty input.getState 1
    echo penalty input.getState 2
    part 1: solve input.getState 1
    part 2: solve input.getState 2