include aoc
import bitops

day 16:
    var workingValves: seq[string]
    var brokenValves: seq[string]
    for line in lines:
        let (_, v, rate, _, _, _, vs) = line.scanTuple"Valve $w has flow rate=$i; $w $w to $w $*"
        if rate > 0:
            workingValves &= v
        else:
            brokenValves &= v
    sort brokenValves
    let valves = workingValves & brokenValves
    var rates = newSeq[int](workingValves.len)
    var times = newSeqWith[int](valves.len ^ 2, 10000)
    func `&`(x, y: int): int = x * valves.len + y
    for line in lines:
        let (_, v, rate, _, _, _, vs) = line.scanTuple"Valve $w has flow rate=$i; $w $w to $w $*"
        let valveId = valves.find v
        if rate > 0:
            rates[valveId] = rate
        for t in vs.split ", ":
            let valve2Id = valves.find t
            times[valveId & valve2Id] = 1
    let aa = valves.find "AA"
    for k in 0..<valves.len:
        for i in 0..<valves.len:
            for j in 0..<valves.len:
                times[i&j] = min(times[i&j], times[i&k] + times[k&j])
    let setSize = 2^workingValves.len
    var memo = newSeqWith((workingValves.len+1) * 30 * setSize * 2, -1)
    proc search(start: int, time: int, closed: int, help: int): int =
        let key = ((start * 30 + time-1) * setSize + closed) * 2 + help
        if memo[key] == -1:
            memo[key] = 0
            for v in closed:
                let t = times[start&v.int]
                if t < time:
                    let newTime = time - 1 - t
                    memo[key] = max(memo[key], rates[v] * newTime + search(v.int, newTime, closed xor (1 shl v), help))
            if help == 1:
                memo[key] = max(memo[key], search(aa, 26, closed, 0))
        return memo[key]
    let fullSet = setSize - 1
    part 1, int:
        search(aa, 30, fullSet, 0)
    part 2, int:
        search(aa, 26, fullSet, 1)
