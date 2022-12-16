include aoc
import memo

day 16:
    var workingValves: seq[string]
    var brokenValves: seq[string]
    for line in lines:
        let (_, v, rate, _, _, _, vs) = line.scanTuple"Valve $w has flow rate=$i; $w $w to $w $*"
        if rate > 0:
            workingValves &= v
        else:
            brokenValves &= v
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
    proc search(start: int, time: int, closed: set[uint8], help: bool): int {.memoized.} =
        for v in closed:
            let t = times[start&v.int]
            if t < time:
                let newTime = time - 1 - t
                result = max(result, rates[v] * newTime + search(v.int, newTime, closed - {v}, help))
        if help:
            result = max(result, search(aa, 26, closed, false))
    let fullSet = toSet toSeq(0'u8..<workingValves.len.uint8)
    part 1, int:
        search(aa, 30, fullSet, false)
    part 2, int:
        search(aa, 26, fullSet, true)
