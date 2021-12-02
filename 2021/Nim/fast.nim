include prelude
import times

const days = 2
const repetitions = 1000
var SOLUTIONS: array[26,proc (input:string):(string,string)]
var INPUTS: array[26,string]
var OUTPUTS: array[26,(string,string)]

for day in 1..days:
    INPUTS[day] = readFile("inputs\\day" & $day & ".in")


SOLUTIONS[1] = proc (input: string):(string, string) =
    func lt(a,b:string): bool =
        if a.len < b.len: return true
        if a.len > b.len: return false
        return a < b
    let start = getTime()
    var parts = input.split
    var p1,p2 = 0
    if parts[0] .lt parts[1]: inc p1
    if parts[1] .lt parts[2]: inc p2
    for i in 3..<parts.len:
        if parts[i-1] .lt parts[i]: inc p1
        if parts[i-3] .lt parts[i]: inc p2
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


var total_time = 0.0
for day in 1..days:
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
    