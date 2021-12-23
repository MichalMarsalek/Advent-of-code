include aoc
import heapqueue

type State = array[8,Point]
func `<`(a,b:(int,State)):bool =
    a[0] < b[0]

day 23:
    echo input
    var state: State
    var seenType = [0,0,0,0]
    for y,row in lines:
        for x,c in row:
            if 'A' <= c and c <= 'D':
                let o = c.ord - 'A'.ord
                state[o*2+seenType[o]] = (x,y)
                seenType[o] += 1
    var initState = state
    echo state
    
    #func getState1(input:string) =
        
    
    func cost(i:int):int = 10^(i div 2)
    func goalX(i:int):int = (3 + i div 2 * 2)
    
    
    func isWin(state:State,i:int):bool =
        state[(i div 2 * 2)..(i div 2 * 2 + 1)].toHashSet == [(i.goalX, 2),(i.goalX, 3)].toHashSet
    
    func isWin(state:State):bool =
        for i in 0..3:
            if state[2*i..2*i+1].toHashSet != [((2*i).goalX, 2),((2*i).goalX, 3)].toHashSet:
                return false
        return true
    
    iterator trackMovement(a,b:int):int =
        var a = a
        while a != b:
            yield a
            a += sgn(b-a)
        yield a
    
    iterator moveOut(v:State, i:int): (int,State) =
        const stops = [1,2,4,6,8,10,11]
        var s = v[i].x
        while (s-1, 1) notin v:
            s -= 1
            if s < 1: break
            if s notin stops: continue
            var copy = v
            copy[i] = (s,1)
            yield ((v[i].x-s + 1)*i.cost, copy)
        s = v[i].x
        while (s+1, 1) notin v:
            s += 1
            if s > 11: break
            if s notin stops: continue
            var copy = v
            copy[i] = (s,1)
            yield ((s-v[i].x + 1)*i.cost, copy)
    
    proc debugState(state:State) =
        var t = input
        for c, p in initState:
            t[p.x + p.y * 14] = '.'
        for c, p in state:
            t[p.x + p.y * 14] = (c div 2 + 'A'.ord).chr
        echo t
        echo ""
    
    
    
    iterator moveIn(v:State, i:int): (int, State) =
        block all:
            if v[i div 2 * 2]     != (i.goalX, 3) and
               v[i div 2 * 2 + 1] != (i.goalX, 3) and
               (3 + i div 2 * 2, 3) in v:
                break all
            for x in trackMovement(v[i].x, i.goalX):
                if (x, 1) in v and v[i] != (x,1):
                    break all
            if (i.goalX, 3) in v:
                var copy = v
                copy[i] = (i.goalX, 2)
                yield (i.cost * (abs(i.goalX - v[i].x) + 1), copy)
            else:
                var copy = v
                copy[i] = (i.goalX, 3)
                yield (i.cost * (abs(i.goalX - v[i].x) + 2), copy)
        
    
    
    iterator neighbours(v:State): (int,State)=
        var needToMoveOut = true
        for i in 0..7:
            if v[i].y == 1:
                for x in moveIn(v, i):
                    yield x
                    needToMoveOut = false
        if needToMoveOut:
            for i in 0..7:
                if v[i].x in [3,5,7,9]:                
                    if v[i].y == 2 and not v.isWin(i):
                        for x in moveOut(v, i):
                            yield x
                    if v[i].x != i.goalX and v[i].y == 3 and v[i]-(0,1) notin v:
                        for (p,x) in moveOut(v, i):
                            yield (p+i.cost,x)
    
    #for (p,x) in neighbours(state):
    #    echo p
    #    debugState(x)
    #echo "n done"
    
    part 1:
        var dist = {state: 0}.toTable
        var seen = [state].toHashSet
        var q = {0:state}.toHeapQueue
        while true:
            let vv = q.pop
            let v = vv[1]
            #echo vv[0]
            #debugState v
            if v.isWin: return dist[v]
            seen.incl v
            for price,u in neighbours(v):
                if u notin seen:
                    let newCost = dist[v] + price
                    if newCost < dist.getOrDefault(u, 2^60):                
                        dist[u] = newCost
                        q.push (dist[u], u)
    part 2:
        0