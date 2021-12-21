include prelude
import times, strscans, math, intsets, algorithm, stats, sugar, bitops, memo

const days = 1..21
const repetitions = 100
var SOLUTIONS: array[26,proc (input:string):(string,string)]
var INPUTS: array[26,string]
var OUTPUTS: array[26,(string,string)]

for day in days:
    INPUTS[day] = readFile("inputs\\day" & $day & ".in")

template solution(d:int, code:untyped): untyped =
    when d in 1..25:
        SOLUTIONS[d] = proc (input {.inject.}: string):(string, string) =
            var p1 {.inject.},p2 {.inject.} = 0
            code
            return ($p1, $p2)
            
solution(1):
    type part = tuple[start: int, len: int]
    func mySplit2(text:string):seq[part] =
        var start = 0
        for i in 0..text.high:
            if text[i] == '\n':
                result.add (start, i-start)
                start = i+1
    proc lt2(a,b:part): bool =
        if a.len < b.len: return true
        if a.len > b.len: return false
        for i in 0..<a.len:
            if input[a.start + i] < input[b.start + i]: return true
            if input[a.start + i] > input[b.start + i]: return false
    var parts = input.mySplit2 # idk why but strutils.split is just so slow
    if parts[0] .lt2 parts[1]: inc p1
    if parts[1] .lt2 parts[2]: inc p1
    for i in 3..<parts.len:
        if parts[i-1] .lt2 parts[i]: inc p1
        if parts[i-3] .lt2 parts[i]: inc p2

solution(2):
    var i = 0
    var x,y,aim = 0
    while i < input.len:
        case input[i]
        of 'u': aim -= input[i+3].ord - 48; i += 5
        of 'd': aim += input[i+5].ord - 48; i += 7
        else:
            let X = input[i+8].ord - 48; x += X; y += aim*X; i += 10
    return ($(x*aim), $(x*y))

solution(3):
    func toInt(x: array[12,int]):int =
        for i in 0..11:
            result = result * 2 + x[i]
            
    #parsing
    var data: seq[array[12,int]]
    var i = 0
    while i < input.len:
        var number: array[12,int]
        for j in 0..11:
            number[j] = input[i+j].ord - 48
        i += 13
        data.add(number)
    
    #part 1
    var most: array[12,int]
    var least: array[12,int]
    
    for i in 0..11:
        var c = 0
        for n in data:
            c += n[i]
            if 2*c >= data.len: break
        most[i] = int(2*c >= data.len)
        least[i] = 1-most[i]
    
    #part 2
    var most_data, least_data = data
    
    i = 0
    while most_data.len > 1:
        var c = 0
        for n in most_data:
            c += n[i]
            if 2*c >= data.len: break
        var most_i = int(2*c >= most_data.len)
        most_data.keepItIf(it[i] == most_i)
        inc i
    i = 0
    while least_data.len > 1:
        var c = 0
        for n in least_data:
            c += n[i]
        var least_i = int(2*c < least_data.len)
        least_data.keepItIf(it[i] == least_i)
        inc i
        
    return ($(most.toInt*least.toInt), $(most_data[0].toInt*least_data[0].toInt))

solution(3):
    #parsing
    var data: seq[uint32]
    var i = 0
    while i < input.len:
        var number = 0'u32
        for j in 0..11:
            number = (number shl 1) xor (input[i+j].ord - 48).uint32
        i += 13
        data.add(number)
    
    #part 1
    var most: uint32
    
    template bit(n:uint32, i:int):uint32 = (n shr i) and 1'u32
        
    
    for i in 0..11:
        var c = 0
        for n in data:
            c += n.bit(11-i).int
            if 2*c >= data.len: break
        most = (most shl 1)
        if 2*c >= data.len:
            most = most xor 1'u32
    var least = (not most) and 0xfff'u32
    
    #part 2
    var most_data, least_data = data
    
    i = 11
    while most_data.len > 1:
        var c = 0
        for n in most_data:
            c += n.bit(i).int
            if 2*c >= most_data.len: break
        var most_i = if 2*c >= most_data.len: 1'u32 else: 0'u32
        most_data.keepItIf(it.bit(i) == most_i)
        dec i
    i = 11
    while least_data.len > 1:
        var c = 0
        for n in least_data:
            c += n.bit(i).int
            if 2*c >= least_data.len: break
        var least_i = if 2*c >= least_data.len: 0'u32 else: 1'u32
        least_data.keepItIf(it.bit(i) == least_i)        
        dec i
        
    return ($(most*least), $(most_data[0]*least_data[0]))

solution(4):
    #parsing
    var nums: seq[int]
    var cards: seq[array[25, int]]
    var checks: seq[array[25, bool]]
    var i,n = 0
    while input[i] != '\n':
        n = input[i].ord - 48
        i+=1
        if input[i] != ',':
            n = n*10 + (input[i].ord - 48)
            i += 2
        else:
            i += 1
        nums.add n
    inc i
    while i < input.len:
        var card: array[25, int]
        for j in 0..24:
            if input[i] == ' ':                
                n = input[i+1].ord - 48
            else:
                n = input[i+1].ord - 48 + (input[i].ord - 48)*10
            i += 3
            card[j] = n
        cards.add card
        var x:array[25, bool]
        checks.add x
        inc i
    var players = newSeq[bool](cards.len)
    
    #game
    proc update(n, i: int):bool =
        for j in 0..<25:
            if cards[i][j] == n:
                checks[i][j] = true
                let row = j div 5 * 5
                let col = j mod 5
                if allIt(0..4, checks[i][row + it]): return true
                if allIt(0..4, checks[i][col + it*5]): return true
                break
    
    proc score(i:int): int =
        for j in 0..24:
            if not checks[i][j]: result += cards[i][j]
    
    var score1, score2 = 0
    for n in nums:
        for i in 0..<cards.len:
            if players[i]: continue
            if update(n, i):
                p2 = i.score*n
                if p1 == 0:
                    p1 = p2
                players[i] = true

solution(4):
    #parsing
    var nums: seq[int]
    var cards: seq[array[25, int]]
    var checks: seq[array[25, bool]]
    var i,n = 0
    while input[i] != '\n':
        n = input[i].ord - 48
        i+=1
        if input[i] != ',':
            n = n*10 + (input[i].ord - 48)
            i += 2
        else:
            i += 1
        nums.add n
    inc i
    while i < input.len:
        var card: array[25, int]
        for j in 0..24:
            if input[i] == ' ':                
                n = input[i+1].ord - 48
            else:
                n = input[i+1].ord - 48 + (input[i].ord - 48)*10
            i += 3
            card[j] = n
        cards.add card
        var x:array[25, bool]
        checks.add x
        inc i
    var players = newSeq[bool](cards.len)
    
    #game
    proc update(n, i: int):bool =
        for j in 0..<25:
            if cards[i][j] == n:
                checks[i][j] = true
                let row = j div 5 * 5
                let col = j mod 5
                if allIt(0..4, checks[i][row + it]): return true
                if allIt(0..4, checks[i][col + it*5]): return true
                break
    
    proc score(i:int): int =
        for j in 0..24:
            if not checks[i][j]: result += cards[i][j]
    
    var score1, score2 = 0
    var first_i,last_i,first_n,last_n = -1
    for n in nums:
        for i in 0..<cards.len:
            if players[i]: continue
            if update(n, i):
                last_i = i
                last_n = n
                if first_i == -1:
                    first_i = i
                    first_n = n
                players[i] = true
    p1 = first_i.score * first_n
    p2 = last_i.score * last_n
    
solution(5):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var pa1, pa2, c1, c2: IntSet
    var total = 0
    while i < input.len:
        var x1 = scanNumber(1)
        var y1 = scanNumber(4)
        var x2 = scanNumber(1)
        var y2 = scanNumber(1)

        for i in 0..max(max(x1, x2)-min(x1, x2),max(y1, y2)-min(y1, y2)):
            total += 1
            let X = x1 + i * sgn(x2-x1)
            let Y = y1 + i * sgn(y2-y1)
            let Z = (X shl 12) xor Y
            if x1 == x2 or y1 == y2:
                if Z in pa1:
                    c1.incl Z
                pa1.incl Z
            if Z in pa2:
                c2.incl Z
            pa2.incl Z
    return ($c1.len, $c2.len)
    
solution(5):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var pa1, pa2: array[1024000, int8]
    var total = 0
    while i < input.len:
        var x1 = scanNumber(1)
        var y1 = scanNumber(4)
        var x2 = scanNumber(1)
        var y2 = scanNumber(1)
        var sx = sgn(x2-x1)
        var sy = sgn(y2-y1)
        var orto = x1 == x2 or y1 == y2
        
        var Z = (x1 shl 10) + y1
        var DZ = ((sx) shl 10) + (sy)
        
        for i in 0..max(abs(x1-x2),abs(y1-y2)):
            total += 1
            if orto:
                pa1[Z] += 1
            else:
                pa2[Z] += 1
            Z += DZ
    var c1,c2 = 0
    for x in pa1:
        if x>1: c1 += 1
    for i in 0..<1024000:
        if pa1[i]+pa2[i]>1: c2 += 1
    return ($c1, $c2)

solution(-5):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var pa1, pa2: array[1024000, int8]
    var total = 0
    while i < input.len:
        var x1 = scanNumber(1)
        var y1 = scanNumber(4)
        var x2 = scanNumber(1)
        var y2 = scanNumber(1)
        
        for i in 0..max(abs(x1-x2),abs(y1-y2)):
            total += 1
            let X = x1 + i * sgn(x2-x1)
            let Y = y1 + i * sgn(y2-y1)
            let Z = (X shl 10) xor Y
            if x1 == x2 or y1 == y2:
                pa1[Z] += 1
            else:
                pa2[Z] += 1
    var c1,c2 = 0
    for x in pa1:
        if x>1: c1 += 1
    for i in 0..<1024000:
        if pa1[i]+pa2[i]>1: c2 += 1
    return ($c1, $c2)

solution(6):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var counter: array[9, int]
    while i < input.len:
        counter[scanNumber(1)] += 1
    
    for i in 1..256:
        var counter0 = counter[0]
        for i in 0..7:
            counter[i] = counter[i+1]      
        counter[8] = counter0
        counter[6] += counter0
        if i == 80:
            p1 = counter.sum
    p2 = counter.sum
    
solution(6):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var counter: array[9, int]
    while i < input.len:
        counter[scanNumber(1)] += 1
    
    for i in 0..255:
        counter[(i+7) mod 9] += counter[i mod 9]        
        if i == 79:
            p1 = counter.sum
    return ($p1, $counter.sum)

func median(data:seq[int]):int =
    var counting: array[2000,int]
    for x in data:
        inc counting[x]
    var cumsum = 0
    for i in 0..<2000:
        cumsum += counting[i]
        if cumsum >= 500:
            return i

solution(7):
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var numbers:seq[int]
    while i < input.len:
        numbers.add scanNumber(1)
    
    #sort numbers
    
    func price(x=0):int = x*(x+1) div 2
    var mean = numbers.mean.int
    var median = numbers.median#numbers[500]
    p1 = numbers.mapIt(abs(it-median)).sum
    p2 = numbers.mapIt(price(abs(it-mean))).sum

solution(8):
    func toSet(text:string):set[char] =
        for x in text: result.incl x
    
    func decode(line: seq[set[char]]):array[4,int] =
        var d1,d4,d8 = {'a'..'g'}
        for g in line:
            if g.card == 2:
                d1 = g; break
        for g in line:
            if g.card == 4:
                d4 = g; break
        for i in 0..3:
            let number = line[10+i]
            let c8 = card number
            if c8 == 7: result[i] = 8; continue
            if c8 == 2: result[i] = 1; continue
            if c8 == 3: result[i] = 7; continue
            if c8 == 4: result[i] = 4; continue
            let c1 = card(d1 * number)
            let c4 = card(d4 * number)
            if c8 == 5:
                if c4 == 2: result[i] = 2; continue
                if c1 == 1: result[i] = 5; continue
                result[i] = 3; continue
            if c4 == 4: result[i] = 9; continue
            if c1 == 1: result[i] = 6; continue
            result[i] = 0            
    
    var lines:seq[seq[set[char]]]
    var i = 0
    var line:seq[set[char]]
    var number:set[char]
    while i < input.len:
        if input[i] == '\n':
            line.add number
            reset number
            lines.add line
            reset line
        elif input[i] == ' ':
            line.add number
            reset number
        elif input[i] == '|':
            i += 1
        else:
            number.incl input[i]
        i += 1
    var temp: array[4, int]
    for line in lines:
        var decoded = decode line
        for i in 0..3:
            if decoded[i] in [1,4,7,8]: p1 += 1
            temp[i] += decoded[i]

solution(8):
    func decode(line: array[14,int8]):array[4,int] =
        var d1,d4,d8 = 0b01111111'i8
        for g in line:
            if g.countSetBits == 2:
                d1 = g; break
        for g in line:
            if g.countSetBits == 4:
                d4 = g; break
        for i in 0..3:
            let number = line[10+i]
            let c8 = countSetBits number
            if c8 == 7: result[i] = 8; continue
            if c8 == 2: result[i] = 1; continue
            if c8 == 3: result[i] = 7; continue
            if c8 == 4: result[i] = 4; continue
            let c1 = countSetBits(d1 and number)
            let c4 = countSetBits(d4 and number)
            if c8 == 5:
                if c4 == 2: result[i] = 2; continue
                if c1 == 1: result[i] = 5; continue
                result[i] = 3; continue
            if c4 == 4: result[i] = 9; continue
            if c1 == 1: result[i] = 6; continue
            result[i] = 0            
    
    var lines:array[200,array[14,int8]]
    var i,j,k = 0
    var line:array[14,int8]
    var number:int8
    while i < input.len:
        if input[i] == '\n':
            line[j] = number
            j = 0
            number = 0
            lines[k] = line
            k += 1
            reset line
        elif input[i] == ' ':
            line[j] = number
            j += 1
            reset number
        elif input[i] == '|':
            i += 1
        else:
            number = number xor (1'i8 shl (input[i].ord - 97))
        i += 1
    var temp: array[4, int]
    for line in lines:
        var decoded = decode line
        for i in 0..3:
            if decoded[i] in [1,4,7,8]: p1 += 1
            temp[i] += decoded[i]
    
    return ($p1, $(temp[0]*1000+temp[1]*100+temp[2]*10+temp[3]))

solution(9):
    var data:array[101*102,int8]
    #parsing
    for i in 0..100: data[i] = 57
    for i in (101*101)..<(101*102): data[i] = 57
    var i = 101
    for y in 0..99:
        for x in 0..99:
            data[i] = input[i-101].ord.int8
            inc i
        data[i] = 57
        inc i
    i = 0
    
    #part1
    var minimums:array[1000,int]
    for p in 101..<(101*102):
        if( data[p]<data[p-1] and
         data[p]<data[p+1] and
         data[p]<data[p-101] and
         data[p]<data[p+101]):
            minimums[i] = p
            p1 += data[p].ord
            inc i
    p1 -= i*47
    
    #part2
    var stack: array[101*102,int]
    var stack_i:int 
    var sizes:array[1000,int]
    for j in 0..<i:
        stack_i = 0
        stack[0] = minimums[j]
        while stack_i >= 0:
            var p = stack[stack_i]
            dec stack_i
            if data[p] < 57:
                inc sizes[i]
                data[p] = 57
                inc stack_i; stack[stack_i] = p-1
                inc stack_i; stack[stack_i] = p+1
                inc stack_i; stack[stack_i] = p-101
                inc stack_i; stack[stack_i] = p+101
    p2 = 1
    for k in 0..2:
        var curmax = k
        for j in k..<i:
            if sizes[j] > sizes[curmax]:
                curmax = j
        p2 *= sizes[curmax]
        sizes[curmax] = sizes[k]

solution(10):
    func fast_split(text:string, sep:char):array[102,string] =
        var i,k = 0
        for j in 0..<text.len:
            if text[j] == sep:
                result[k] = text[i..<j]
                inc k
                i = j + 1
    
    func toArrayTable[T](data:openarray[(char,T)]):array[128,int] =
        for (k,v) in data:
            result[k.ord] = v.ord
       
    const brackets = {'(':')','[':']','{':'}','<':'>'}.toArrayTable
    const scores1 = {')':3,']':57,'}':1197,'>':25137}.toArrayTable
    const scores2 = {')':1,']':2,'}':3,'>':4}.toArrayTable
    
    var lines = input.fastsplit '\n'
    var score2s: seq[int]
    
    proc score(line:int) =
        var stack: array[200,int]
        var stack_i = -1
        var unexpected = false
        for e in lines[line]:
            let eord = e.ord
            if brackets[eord] > 0:
                inc stack_i
                stack[stack_i] = brackets[eord]
            else:
                if stack[stack_i] == eord:
                    dec stack_i
                else:
                    p1 += scores1[eord]
                    unexpected = true
                    break
        if not unexpected:
            var part2 = 0
            for bi in countdown(stack_i,0):
                part2 = part2*5 + scores2[stack[bi]]
            score2s.add part2
            
    for i in 0..<lines.len:
        score i
    p2 = score2s.sorted[score2s.len div 2]

solution(11):
    var grid:array[11*12+1,int8]
    #parsing
    var i = 0
    for y in 0..9:
        for x in 0..9:
            grid[i+12] = int8(input[i].ord-48)
            inc i
        inc i
    
    proc update():int =
        var stack: array[1000,int]
        var stack_i = -1
        for x in 0..9:
            for y in 1..10:
                let p = y*11+x+1
                grid[p] += 1
                inc stack_i
                stack[stack_i] = p
        while stack_i >= 0:
            let p = stack[stack_i]
            dec stack_i
            if grid[p] >= 10:
                grid[p] = 0
                inc result
                for P in [p-12,p-11,p-10,p-1,p+1,p+10,p+11,p+12]:
                    if grid[P] > 0:
                        grid[P] += 1
                        inc stack_i
                        stack[stack_i] = P
    for i in 1..69_420:
        let f = update()
        if i <= 100: p1 += f
        if f == 100:
            return ($p1, $i)

solution(12):
    #parsing
    var ids: Table[string,int]
    var neighbours: array[20, array[20, int]]
    var isLarge: array[20, bool]
    var curr_id = 0
    var start,goal = 0
    for line in input.strip.splitLines:
        let parts = line.split('-')
        let (a,b) = (parts[0], parts[1])
        if a notin ids:
            ids[a] = curr_id
            inc curr_id
        if b notin ids:
            ids[b] = curr_id
            inc curr_id
        let ida = ids[a]
        let idb = ids[b]
        if a[0].isUpperAscii: isLarge[ida] = true
        if b[0].isUpperAscii: isLarge[idb] = true
        if a == "start": start = ida
        if a == "end":   goal  = ida
        if b == "start": start = idb
        if b == "end":   goal  = idb
        neighbours[ida][0] += 1
        neighbours[ida][neighbours[ida][0]] = idb
        neighbours[idb][0] += 1
        neighbours[idb][neighbours[idb][0]] = ida
    var visited: array[20, bool]
    
    func inv(x:int):string =
        for k,v in ids:
            if v == x:
                return k
    proc traverse(last:int, res: var int, comeback=false) =
        if last == goal:
            inc res
        else:
            for cave_i in 1..neighbours[last][0]:
                let cave = neighbours[last][cave_i]
                if isLarge[cave]:
                    traverse(cave, res, comeback)
                elif not visited[cave]:
                    visited[cave] = true
                    traverse(cave, res, comeback)
                    visited[cave] = false
                elif comeback and cave != start:
                    traverse(cave, res, false)
    visited[start] = true
    traverse(start, p1)
    traverse(start, p2, true)

solution(12): # optimize this further by packing more densely and switching from table to array
    #parsing
    var ids: Table[string,int]
    var neighbours: array[20, array[20, int]]
    var isLarge: array[20, bool]
    var curr_id = 0
    var start,goal = 0
    for line in input.strip.splitLines:
        let parts = line.split('-')
        let (a,b) = (parts[0], parts[1])
        if a notin ids:
            ids[a] = curr_id
            inc curr_id
        if b notin ids:
            ids[b] = curr_id
            inc curr_id
        let ida = ids[a]
        let idb = ids[b]
        if a[0].isUpperAscii: isLarge[ida] = true
        if b[0].isUpperAscii: isLarge[idb] = true
        if a == "start": start = ida
        if a == "end":   goal  = ida
        if b == "start": start = idb
        if b == "end":   goal  = idb
        neighbours[ida][0] += 1
        neighbours[ida][neighbours[ida][0]] = idb
        neighbours[idb][0] += 1
        neighbours[idb][neighbours[idb][0]] = ida
    
    func inv(x:int):string =
        for k,v in ids:
            if v == x:
                return k
    
    var memo: Table[int,int]
    proc count_paths(state: int): int =
        if state in memo:
            return memo[state]
        #state = start or (comeback shl 5) or (visited shl 6)
        let start = state and 0b11111
        let comeback = state and 0b100000
        let visited = state shr 6
        if start == goal:
            memo[state] = 1
            return 1
        else:
            for cave_i in 1..neighbours[start][0]:
                let cave = neighbours[start][cave_i]
                if isLarge[cave]:
                    result += count_paths(state xor start xor cave)
                elif ((visited shr cave) and 1) == 0:
                    result += count_paths(state xor start xor cave xor (1 shl (cave+6)))
                elif comeback == 0b100000 and cave != start:
                    result += count_paths(state xor start xor cave xor 0b100000)
        memo[state] = result
    p1 = count_paths(start or (1 shl (start+6)))
    p2 = count_paths(start or (1 shl (start+6)) or 0b100000)

solution(13):
    #parsing
    var points: array[1000, (int,int)]
    var folds: array[12, (int,int)]
    var result: array[40*6, char]
    result.fill(' ')
    for y in 0..5: result[y*40+39] = '\n'
    let lines = input.splitLines
    var pointsCount = 0
    while lines[pointsCount] != "":
        let (ok,x,y) = lines[pointsCount].scanTuple("$i,$i")
        points[pointsCount] = (x,y)
        inc pointsCount
    for i in 1..12:
        let number = lines[pointsCount + i][13..^1].parseInt
        if lines[pointsCount + i][11] == 'x':
            folds[i-1] = (number, 0)
        else:
            folds[i-1] = (0, number)
    #part 1
    var points2: IntSet
    for i in 0..<pointsCount:
        var p = points[i]
        let f = folds[0]
        if f[0] == 0 and p[1] > f[1]:
            p = (p[0], 2*f[1] - p[1])
        elif f[1] == 0 and p[0] > f[0]:
            p = (2*f[0] - p[0], p[1])
        points2.incl (p[0] shl 10 or p[1])
    
    #part 2
    for i in 0..<pointsCount:
        var p = points[i]
        for f in folds:
            if f[0] == 0 and p[1] > f[1]:
                p = (p[0], 2*f[1] - p[1])
            elif f[1] == 0 and p[0] > f[0]:
                p = (2*f[0] - p[0], p[1])
        result[p[0] + p[1]*40] = '#'
    return ($points2.len, result.join)
    
solution(14):
    func nxt(pairs: CountTable[string], rules:Table[string,char]):CountTable[string] =
        for k,v in pairs:
            if k in rules:
                result.inc(k[0] & rules[k], v)
                result.inc(rules[k] & k[1], v)
    
    func solve(templ:string, rules:Table[string, char], rounds:int):int =
        var s = mapIt(1..<templ.len, templ[it-1..it]).toCountTable
        for _ in 1..rounds:
            s = s.nxt(rules)
        var counts = [templ[0]].toCountTable
        for k,v in s:
            counts.inc(k[1], v)
        counts.largest[1] - counts.smallest[1]
    
    let lines = input.strip.splitLines
    let templ = lines[0]
    var rules:Table[string, char]
    for L in lines[2..^1]:
        let p = L.split(" -> ")
        rules[p[0]] = p[1][0]
        
    p1 = solve(templ, rules, 10)
    p2 = solve(templ, rules, 40)    

solution(15):
    #parsing
    var prices:array[501*502,int8]
    var dist:array[501*502,int16]
    dist.fill(int16.high)
    var seen:array[501*502,bool]
    var buffers:array[11,seq[int]]
    var buffer_i = 0
    for i in 0..500: seen[i] = true
    for i in 0..500: seen[i*501+500] = true
    for i in (501*501)..<(501*502): seen[i] = true
    for y in 0..499:
        for x in 0..499:
            prices[501*(y+1)+x] = int8((input[101*(y mod 100) + (x mod 100)].ord + y div 100 + x div 100 - 40) mod 9 + 1)
    
    proc push(x:int, priority:int) =
        let bi = priority mod 11
        buffers[bi].add x
    proc pop(): int =
        while buffers[buffer_i].len == 0:
            buffer_i = (buffer_i + 1) mod 11
        return pop buffers[buffer_i]
    push(501,0)
    dist[501] = 0
    
    let goal = 501*501 - 2
    while true:
        let v = pop()
        if v == goal: break
        seen[v] = true
        for u in [v-501,v-1,v+1,v+501]:
            if not seen[u]:
                let newCost = dist[v] + prices[u]
                if newCost < dist[u]:                
                    dist[u] = newCost
                    push(u,dist[u])
    p1 = dist[100*501 + 99]
    p2 = dist[goal]
        

solution(16):
    #var input = "38006F45291200"
    var data: array[6000,int]
    var i = 0
    for c in input:
        let v = c.ord - (if c >= 'A': 55 else: 48)
        data[i] = v shr 3 and 1; inc i
        data[i] = v shr 2 and 1; inc i
        data[i] = v shr 1 and 1; inc i
        data[i] = v shr 0 and 1; inc i
    i = 0
    proc scanNumber(size:int):int =
        for _ in 1..size:
            result = result shl 1 or data[i]
            inc i
    
    proc parse(): int =
        p1 += scanNumber(3)
        let typeID = scanNumber(3)
        if typeID == 4:
            while true:
                let temp = scanNumber(5)
                if temp >= 16:
                    result = result shl 4 + temp and 0b1111
                else:
                    return result shl 4 + temp
        let lengthType = scanNumber(1)
        var children:seq[int]
        if lengthType == 0: 
            let bitLength = scanNumber(15)
            let target = i + bitLength
            while target > i:
                children.add parse()
        else:
            let packetCount = scanNumber(11)
            while children.len < packetCount:
                children.add parse()
        return case typeID
        of 0: children.sum
        of 1: children.prod
        of 2: children.min
        of 3: children.max
        of 5: int(children[0] >  children[1])
        of 6: int(children[0] <  children[1])
        else: int(children[0] == children[1])
    
    i = 0
    p2 = parse()

solution(17):
    let (_, lx, ux, ly, uy) = scanTuple(input, "target area: x=$i..$i, y=$i..$i")
    var triangle = 0
    var stabilized: IntSet
    var hitting: HashSet[(int, int)]
    for i in 1..1-2*ly:
        let miny = ceil(ly.float/i.float + float(i-1)/2.0).int
        let maxy = floor(uy.float/i.float + float(i-1)/2.0).int
        let minx = max(i, ceil(lx.float/i.float + float(i-1)/2.0).int)
        let maxx = floor(ux.float/i.float + float(i-1)/2.0).int
        if lx <= triangle and triangle <= ux:
            stabilized.incl i-1
        #dump i
        #dump minx..maxx
        #dump miny..maxy
        #dump stabilized
        
        for y in miny..maxy:
            for x in stabilized:
                hitting.incl (x,y)
            for x in minx..maxx:
                hitting.incl (x,y)
        triangle += i
    p2 = card hitting


import aoc_logic 
    
        

solution(170):
    let (_, lx, ux, ly, uy) = scanTuple(input, "target area: x=$i..$i, y=$i..$i")
    var triangle = 0
    var stabilized: RangeUnion
    var hitting: Table[int,RangeUnion]
    for i in 1..1-2*ly:
        let shift = float(i-1)/2.0
        let ifloat = i.float
        let miny = ceil(ly.float/ifloat + shift).int
        let maxy = floor(uy.float/ifloat + shift).int
        if miny > maxy:continue
        let minx = max(i, ceil(lx.float/ifloat + shift).int)
        let maxx = floor(ux.float/ifloat + shift).int
        if lx <= triangle and triangle <= ux:
            stabilized = stabilized + (i-1,i-1)
            
        for y in miny..maxy:
            hitting[y] = hitting.getOrDefault(y, emptyRangeUnion) + stabilized
            hitting[y] = hitting.getOrDefault(y, emptyRangeUnion) + (minx, maxx)
        triangle += i
    p2 = hitting.values.toSeq.map(card).sum

solution(18):
    type NodeRef = ref object
        ## Snailfish number type
        value: int
        left, right: NodeRef
    
    func newNode(val:int): NodeRef =
        ## Returns a new regular number (leaf node)
        result = new(NodeRef)
        result.value = val
    func newNode(left, right: NodeRef): NodeRef =
        ## Returns a new snailfish number composed of the given two parts.
        result = new(NodeRef)
        result.left = left
        result.right = right
    
    func `$`(x:NodeRef):string =
        ## Returns a string representation of the snailfish number. Needed just for debugging.
        if x == nil: return "nil"
        if x.left == nil: return $x.value
        return ("[" & $x.left & "," & $x.right & "]")
    
    func parse(data: string): NodeRef =
        ## Returns the root node of the snailfish number
        ## represented by the given string
        var i = 0
        proc scanNumber(): int =
            while data[i] in Digits:
                result = result * 10 + data[i].ord - '0'.ord
                inc i
    
        proc parse0(): NodeRef =
            if data[i] == '[':
                inc i
                let left = parse0()
                inc i
                let right = parse0()
                inc i
                return newNode(left, right)
            else:
                return newNode scanNumber()
        return parse0()
    
    proc toExplode(number: NodeRef):bool =
        ## Performs the explode operation on the given snailfish number.
        ## Returns true iff the explosion happened.
        
        ## Last node encountered. When depth 4 pair is encountered
        ## the left number is to be added to this node-
        var lastLeft:NodeRef = nil
        
        ## The right value of the depth 4 pair or -1 at start.
        ## When any next regular value is encounter this is to be added to it.
        var explodedRight = -1        
        
        ## Indicates whether explodedRight was already added to some node.
        var explodedPlaced = false
        
        proc traverse(number: NodeRef, depth = 0) =
            if explodedPlaced: return
            if depth == 4 and number.left != nil and explodedRight == -1:
                if lastLeft != nil: lastLeft.value += number.left.value
                explodedRight = number.right.value
                number.left = nil
                number.right = nil
                number.value = 0
                return
            if explodedRight == -1:
                if number.left == nil:
                    lastLeft = number
            else:
                if number.left == nil:
                    number.value += explodedRight
                    explodedPlaced = true
            if number.left != nil:
                traverse(number.left, depth+1)
                traverse(number.right, depth+1)
        traverse number
        return explodedRight > -1
    
    proc toSplit(number: NodeRef): bool =
        ## Performs the split operation on the given snailfish number.
        ## Returns true iff the splitting happened.
        var done = false
        proc traverse(number: NodeRef) =
            if done: return
            if number.left == nil and number.value >= 10:
                done = true
                number.left = newNode(number.value div 2)
                number.right = newNode(number.value - number.value div 2)
            elif number.left != nil:
                traverse number.left
                traverse number.right
        traverse number
        return done
    
    proc toReduce(number: NodeRef) =
        ## Iterates the explode and split operations until nothing changes.        
        while true:
            if toExplode(number): continue
            if not toSplit(number): break
    
    func `+`(a,b: NodeRef): NodeRef =
        ## Adds two snailfish numbers.
        result = newNode(deepcopy a, deepcopy b)
        toReduce result
    
    func magnitude(a: NodeRef): int =
        ## Calculates the magnitude of a snailfish number.
        if a.left == nil: return a.value
        return 3*a.left.magnitude + 2*a.right.magnitude
    
    let numbers = input.splitLines.map(parse)
    p1 = magnitude numbers.foldl(a + b)
    p2 = 0
    for i,a in numbers:
        for j,b in numbers:
            if i != j:
                p2 = max(p2, magnitude(a+b))

solution(18):
    type Number = seq[tuple[val:int,depth:int8]]
    var numbers: array[100,Number]
    var i,depth = 0
    for c in input:
        if c == '\n':
            inc i
            depth = 0
        elif c == '[':
            inc depth
        elif c == ']':
            dec depth
        elif c == ',':discard
        else:
            numbers[i].add (c.ord-48, int8 depth)
    
    proc toRepeatedExplode0(number: var Number) =
        # TODO this should be done in 1 pass to be useful
        var deleted: seq[int]
        var i = 0
        while i < number.len:
            if number[i].depth == 5:
                if i > 0:
                    number[i-1].val += number[i].val
                if i < number.len - 2:
                    number[i+2].val += number[i+1].val
                number[i+1] = (0, number[i].depth-1i8)
                deleted.add i
                inc i
            inc i
        deleted.add number.len
        var cdeleted = 1
        var last = deleted[0]
        for ix,d in deleted:
            if ix == 0:continue
            for i in last+1..<d:
                number[i-cdeleted] = number[i]
            inc cdeleted
            last = d
        number.setLen number.len-cdeleted+1
    
    proc toExplode(number: var Number, hint=0): int =
        for i in hint..<number.len:
            if number[i].depth == 5:
                if i > 0:
                    number[i-1].val += number[i].val
                if i < number.len - 2:
                    number[i+2].val += number[i+1].val
                number[i] = (0, number[i].depth-1i8)
                number.delete(i+1)
                return i
        return -1
            
    proc toSplit(number: var Number, hint=0): int =
        for i in hint..<number.len:
            if number[i].val >= 10:
                let left = number[i].val div 2
                let right = number[i].val - left
                let depth = number[i].depth + 1
                number[i] = (left, depth)
                number.insert((right, depth), i + 1)
                return i
        return -1
        
    proc toReduce(number: var Number) =
        while true:
            var start = 0
            while start >= 0:
                start = toExplode(number, start)            
            if toSplit(number, 0) < 0: return
    
    func `+`(a,b: Number): Number =
        result = a & b
        for i in 0..<result.len: inc result[i].depth
        toReduce result
    
    func magnitude(a: Number): int =
        var stack: Number
        for pair in a:
            var pair = pair
            while stack.len > 0 and stack[^1].depth == pair.depth:
                let left = pop stack
                pair = (3*left.val + 2*pair.val, pair.depth - 1)
            stack.add pair
        assert stack.len == 1
        assert stack[0].depth == 0
        return stack[0].val
    
    p1 = magnitude numbers.foldl(a + b)
    p2 = 0
    for i,a in numbers:
        for j,b in numbers:
            if i != j:
                p2 = max(p2, magnitude(a+b))

solution(19):
    var scanners = input.strip.split("\n\n").map(B => B.splitLines[1..^1].map ints3)
    var fingerprints: seq[Table[int,(int, int)]]
    for scanner in scanners:
        var t:Table[int,(int, int)]
        for i,a in scanner:
            for j in 0..<i:
                let b = scanner[j]
                t[(a.x-b.x)^2 + (a.y-b.y)^2 + (a.z-b.z)^2] = (i,j)
        fingerprints.add t
    var fixed = [0].toHashSet
    var notFixed = (1..<scanners.len).toSeq.toHashSet
    
    type Transform = tuple[perm, signs, shift: Point3]
    
    iterator findTransform(fixed, other: (Point3, Point3)): Transform =
        let dFixed = fixed[1] - fixed[0]
        let dOther0 = other[1] - other[0]
        let dOther = [dOther0.x, dOther0.y, dOther0.z]
        let other0 = [other[0].x, other[0].y, other[0].z]
        let other1 = [other[1].x, other[1].y, other[1].z]
        block all:
            for (a,b,c) in [(0,1,2),(0,2,1),(1,0,2),(1,2,0),(2,0,1),(2,1,0)]:
                if dFixed[0].abs == dOther[a].abs and dFixed[1].abs == dOther[b].abs and  dFixed[2].abs == dOther[c].abs:
                 for Sx in (if dOther[a] == 0: @[-1,1] else: @[dFixed[0] div dOther[a]]):
                  for Sy in (if dOther[b] == 0: @[-1,1] else: @[dFixed[1] div dOther[b]]):
                   for Sz in (if dOther[c] == 0: @[-1,1] else: @[dFixed[2] div dOther[c]]):
                    var sx = Sx * other0[a] - fixed[0].x
                    var sy = Sy * other0[b] - fixed[0].y
                    var sz = Sz * other0[c] - fixed[0].z
                    yield ((a,b,c), (Sx,Sy,Sz), (sx,sy,sz))
                    sx = -Sx * other1[a] - fixed[0].x
                    sy = -Sy * other1[b] - fixed[0].y
                    sz = -Sz * other1[c] - fixed[0].z
                    yield ((a,b,c), -(Sx,Sy,Sz), (sx,sy,sz))
    
    func applyTrans(p: Point3, trans:Transform): Point3 =
        let pp = [p.x, p.y, p.z]
        return (pp[trans.perm.x] * trans.signs.x,
                pp[trans.perm.y] * trans.signs.y,
                pp[trans.perm.z] * trans.signs.z) - trans.shift
    
    var shifts:seq[Point3]
    
    proc fix(j:int, transform:Transform) =
        fixed.incl j
        notFixed.excl j
        shifts.add transform.shift
        scanners[j] = scanners[j].mapIt(it.applyTrans transform)
    
    var tried: HashSet[(int,int)]
    
    while notFixed.card > 0:
        block step:
            for i in fixed:
                for j in notFixed:
                    if (i,j) in tried: continue
                    var overlap: array[200,int]
                    var overlap_count = 0
                    for a in fingerprints[i].keys:
                        if a in fingerprints[j]:
                            overlap[overlap_count] = a
                            inc overlap_count
                    #dump (i,j, fixed, notFixed, overlap.len)
                    if overlap_count >= 66:
                        #echo (i, j, overlap.len)
                        var transforms: HashSet[Transform]
                        var top: Transform
                        block loopD:
                            for di in 0..<overlap_count:
                                let d = overlap[di]
                                let a = (scanners[i][fingerprints[i][d][0]],scanners[i][fingerprints[i][d][1]])
                                let b = (scanners[j][fingerprints[j][d][0]],scanners[j][fingerprints[j][d][1]])
                                for trans in findTransform(a,b):
                                    if trans in transforms:
                                        top = trans
                                        break loopD
                                    transforms.incl trans
                        fix(j, top)
                        break step
                    tried.incl (i,j)
    var beacons: IntSet
    for s in scanners:
        for p in s:
            beacons.incl p.x shl 40 or p.y shl 20 or p.z
    p1 = beacons.card
    for i,s1 in shifts:
        for s2 in shifts[0..<i]:
            p2 = max(p2, norm1(s1-s2))

solution(20):
    var rules:array[512,int16]
    var grids:array[2*200*200,int16]
    for i in 0..511:
        rules[i] = int16(input[i] == '#')
    var default = 0i16
    var current = 0
    
    var L = 50
    var H = 149
    for y in 0..99:
        for x in 0..99:
            grids[(L+y)*200 + L + x] = int16(input[514 + y*101 + x] == '#')
            
    proc get(x,y:int):int16 =
        if x < L or x > H or y < L or y > H:
            return default
        grids[current + y*200+x]
    
    proc update() =
        for x in L-1..H+1:
            for y in L-1..H+1:
                let index = get(x-1,y-1) shl 8 or
                            get(x,y-1) shl 7 or
                            get(x+1,y-1) shl 6 or
                            get(x-1,y) shl 5 or
                            get(x,y) shl 4 or
                            get(x+1,y) shl 3 or
                            get(x-1,y+1) shl 2 or
                            get(x,y+1) shl 1 or
                            get(x+1,y+1)
                grids[40000-current + y*200+x] = rules[index]
        L -= 1
        H += 1
        current = 40000 - current
        default = 1i16 - default
    
    proc count(): int =
        for x in L..H:
            for y in L..H:
                result += grids[current + y*200+x]
    
    update()
    update()
    p1 = count()
    for _ in 3..50:
        update()
    p2 = count()
 
solution(20):
    var rules:array[512,int16]
    var grid0:array[200*200,int16]
    var grid1:array[200*200,int16]
    for i in 0..511:
        rules[i] = int16(input[i] == '#')
    
    var L = 50
    var H = 149
    for y in 0..99:
        for x in 0..99:
            grid0[(L+y)*200 + L + x] = int16(input[514 + y*101 + x] == '#')
            
    proc get0(x,y:int):int16 =
        if x < L or x > H or y < L or y > H:
            return 0i16
        grid0[y*200+x]
    proc get1(x,y:int):int16 =
        if x < L or x > H or y < L or y > H:
            return 1i16
        grid1[y*200+x]
    
    proc update() =
        for x in L-1..H+1:
            for y in L-1..H+1:
                let index = get0(x-1,y-1) shl 8 or
                            get0(x,y-1)   shl 7 or
                            get0(x+1,y-1) shl 6 or
                            get0(x-1,y)   shl 5 or
                            get0(x,y)     shl 4 or
                            get0(x+1,y)   shl 3 or
                            get0(x-1,y+1) shl 2 or
                            get0(x,y+1)   shl 1 or
                            get0(x+1,y+1)
                grid1[y*200+x] = rules[index]
        L -= 1
        H += 1
        for x in L-1..H+1:
            for y in L-1..H+1:
                let index = get1(x-1,y-1) shl 8 or
                            get1(x,y-1)   shl 7 or
                            get1(x+1,y-1) shl 6 or
                            get1(x-1,y)   shl 5 or
                            get1(x,y)     shl 4 or
                            get1(x+1,y)   shl 3 or
                            get1(x-1,y+1) shl 2 or
                            get1(x,y+1)   shl 1 or
                            get1(x+1,y+1)
                grid0[y*200+x] = rules[index]
        L -= 1
        H += 1
    
    proc count(): int =
        for x in L..H:
            for y in L..H:
                result += grid0[y*200+x]
    
    update()
    p1 = count()
    for _ in 1..24:
        update()
    p2 = count()

solution(20):
    var rules:array[512,int16]
    var grid0:array[200*200,int16]
    var grid1:array[200*200,int16]
    for i in 0..511:
        rules[i] = int16(input[i] == '#')
    
    var L = 50
    var H = 149
    for y in 0..99:
        for x in 0..99:
            grid0[(L+y)*200 + L + x] = int16(input[514 + y*101 + x] == '#')
            
    proc get0(x,y:int):int16 =
        if x < L or x > H or y < L or y > H:
            return 0i16
        grid0[y*200+x]
    proc get1(x,y:int):int16 =
        if x < L or x > H or y < L or y > H:
            return 1i16
        grid1[y*200+x]
    
    template generalCase0():untyped {.dirty.} =
        block:
            let index = get0(x-1,y-1) shl 8 or
                        get0(x,y-1)   shl 7 or
                        get0(x+1,y-1) shl 6 or
                        get0(x-1,y)   shl 5 or
                        get0(x,y)     shl 4 or
                        get0(x+1,y)   shl 3 or
                        get0(x-1,y+1) shl 2 or
                        get0(x,y+1)   shl 1 or
                        get0(x+1,y+1)
            grid1[y*200+x] = rules[index]
    template generalCase1():untyped {.dirty.} =
        block:
            let index = get1(x-1,y-1) shl 8 or
                        get1(x,y-1)   shl 7 or
                        get1(x+1,y-1) shl 6 or
                        get1(x-1,y)   shl 5 or
                        get1(x,y)     shl 4 or
                        get1(x+1,y)   shl 3 or
                        get1(x-1,y+1) shl 2 or
                        get1(x,y+1)   shl 1 or
                        get1(x+1,y+1)
            grid0[y*200+x] = rules[index]
    
    template innerCase0():untyped {.dirty.} =
        block:
            let index = grid0[i-201] shl 8 or
                        grid0[i-200] shl 7 or
                        grid0[i-199] shl 6 or
                        grid0[i-1]   shl 5 or
                        grid0[i]     shl 4 or
                        grid0[i+1]   shl 3 or
                        grid0[i+199] shl 2 or
                        grid0[i+200] shl 1 or
                        grid0[i+201]
            grid1[i] = rules[index]
    template innerCase1():untyped {.dirty.} =
        block:
            let index = grid1[i-201] shl 8 or
                        grid1[i-200] shl 7 or
                        grid1[i-199] shl 6 or
                        grid1[i-1]   shl 5 or
                        grid1[i]     shl 4 or
                        grid1[i+1]   shl 3 or
                        grid1[i+199] shl 2 or
                        grid1[i+200] shl 1 or
                        grid1[i+201]
            grid0[i] = rules[index]
    
    
    proc update() =
        var x,y:int
        y = L-1
        for x in L-1..H+1:
            generalCase0()
        y = L
        for x in L-1..H+1:
            generalCase0()
        for y in L+1..H-1:
            x = L-1
            generalCase0()
            x = L
            generalCase0()
            var i = y*200 + L+1
            for x in L+1..H-1:
                innerCase0()
                inc i
            x = H
            generalCase0()
            x = H+1
            generalCase0()
        y = H
        for x in L-1..H+1:
            generalCase0()
        y = H+1
        for x in L-1..H+1:
            generalCase0()
        L -= 1
        H += 1

        y = L-1
        for x in L-1..H+1:
            generalCase1()
        y = L
        for x in L-1..H+1:
            generalCase1()
        for y in L+1..H-1:
            x = L-1
            generalCase1()
            x = L
            generalCase1()
            var i = y*200 + L+1
            for x in L+1..H-1:
                innerCase1()
                inc i
            x = H
            generalCase1()
            x = H+1
            generalCase1()
        y = H
        for x in L-1..H+1:
            generalCase1()
        y = H+1
        for x in L-1..H+1:
            generalCase1()
        L -= 1
        H += 1
    
    proc count(): int =
        for x in L..H:
            for y in L..H:
                result += grid0[y*200+x]
    
    update()
    p1 = count()
    for _ in 1..24:
        update()
    p2 = count()

solution(21):
    let pos1s = input[28].ord - 48
    let pos2s = input[58].ord - 48
    var pos1 = pos1s
    var pos2 = pos2s
    var score1, score2, i = 0
    proc genRolls():seq[int] =
        result.add -1
        var countRolls:int = 0
        for _ in 1..500:
            var roll = -1
            for _ in 1..3:
                inc countRolls
                roll += (countRolls + 99) mod 100 + 1
            result.add roll
    const rolls = genRolls()
    
    while true:
        inc i
        pos1 = (pos1 + rolls[i]) mod 10 + 1
        score1 += pos1
        if score1 >= 1000:
            p1 = score2 * i * 3
            break
        inc i
        pos2 = (pos2 + rolls[i]) mod 10 + 1
        score2 += pos2
        if score2 >= 1000:
            p1 = score1 * i * 3
            break
    
    var memo: array[21*21*10*10, (int,int)]
    memo.fill((-1,-1))
    func countWins(p1, p2, s1, s2: int): (int,int) =
        const rolls = {3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1}
        if s1 >= 21 or s2 >= 21:
            return (int(s1>=21), int(s2>=21))
        let key = ((p1*10 + p2)*21 + s1)*21 + s2
        if memo[key][0] > -1:
            return memo[key]
        for (roll,freq) in rolls:
            let p = (p1 + roll) mod 10
            let w = countWins(p2, p, s2, s1 + p + 1)
            result[0] += freq*w[1]
            result[1] += freq*w[0]
        memo[key] = result
        
    p2 = countWins(pos1s-1, pos2s-1, 0, 0)[0]

var total_time = 0.0
for day in days:
    let start = getTime()
    for _ in 1..repetitions:
        OUTPUTS[day] = SOLUTIONS[day] INPUTS[day]       

    let finish = getTime()
    let mean_time = (finish-start).inNanoseconds.float / repetitions.float / 1000000.0
    total_time += mean_time
    
    echo "Day ", day
    echo OUTPUTS[day]
    echo mean_time, " ms"
    echo ""
echo "Total time: ", total_time, " ms"
    