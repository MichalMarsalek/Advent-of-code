include prelude
import times, strscans, math, intsets, algorithm, stats

const days = 1..7
const repetitions = 1000
var SOLUTIONS: array[26,proc (input:string):(string,string)]
var INPUTS: array[26,string]
var OUTPUTS: array[26,(string,string)]

for day in days:
    INPUTS[day] = readFile("inputs\\day" & $day & ".in")



            

SOLUTIONS[1] = proc (input: string):(string, string) =
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
    var p1,p2 = 0
    if parts[0] .lt2 parts[1]: inc p1
    if parts[1] .lt2 parts[2]: inc p1
    for i in 3..<parts.len:
        if parts[i-1] .lt2 parts[i]: inc p1
        if parts[i-3] .lt2 parts[i]: inc p2
    return ($p1, $p2)

SOLUTIONS[2] = proc (input: string):(string, string) =
    var i = 0
    var x,y,aim = 0
    while i < input.len:
        case input[i]
        of 'u': aim -= input[i+3].ord - 48; i += 5
        of 'd': aim += input[i+5].ord - 48; i += 7
        else:
            let X = input[i+8].ord - 48; x += X; y += aim*X; i += 10
    return ($(x*aim), $(x*y))

SOLUTIONS[3] = proc (input: string):(string, string) =
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

SOLUTIONS[3] = proc (input: string):(string, string) =
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

SOLUTIONS[4] = proc (input: string):(string, string) =
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
                score2 = i.score*n
                if score1 == 0:
                    score1 = score2
                players[i] = true
    return ($score1, $score2)
    
SOLUTIONS[5] = proc (input: string):(string, string) =
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var p1, p2, c1, c2: IntSet
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
                if Z in p1:
                    c1.incl Z
                p1.incl Z
            if Z in p2:
                c2.incl Z
            p2.incl Z
    return ($c1.len, $c2.len)
    
SOLUTIONS[5] = proc (input: string):(string, string) =
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var p1, p2: array[1024000, int8]
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
                p1[Z] += 1
            else:
                p2[Z] += 1
    var c1,c2 = 0
    for x in p1:
        if x>1: c1 += 1
    for i in 0..<1024000:
        if p1[i]+p2[i]>1: c2 += 1
    return ($c1, $c2)

SOLUTIONS[6] = proc (input: string):(string, string) =
    var i = 0
    template scanNumber(skip=0):int =
        var n = 0
        while input[i] in Digits:
            n = n*10 + input[i].ord - 48
            i += 1
        i += skip
        n
    var p1, p2 = 0
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
    return ($p1, $p2)

SOLUTIONS[7] = proc (input: string):(string, string) =
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
    
    sort numbers
    
    func price(x=0):int = x*(x+1) div 2
    var mean = numbers.mean.int
    var p1 = numbers.mapIt(abs(it-numbers[500])).sum
    var p2 = numbers.mapIt(price(abs(it-mean))).sum
    return ($p1, $p2)

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
    