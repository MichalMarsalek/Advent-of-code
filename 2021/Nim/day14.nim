include aoc

day 14:    
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
    
    let templ = lines[0]
    var rules:Table[string, char]
    for L in lines[2..^1]:
        let p = L.split(" -> ")
        rules[p[0]] = p[1][0]
        
    part 1: solve(templ, rules, 10)
    part 2: solve(templ, rules, 40)