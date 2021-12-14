include aoc

day 14:    
    func nxt(templ: Table[string,int], rules:Table[string,char]):Table[string, int] =
        result = templ
        for k,v in templ:
            if k in rules:
                result[k] -= v
                result[k[0] & rules[k]] = result.mgetorput(k[0] & rules[k],0) + v
                result[rules[k] & k[1]] = result.mgetorput(rules[k] & k[1],0) + v
    func prepare(templ:string): Table[string,int] =
        for (a,b) in zip(templ, templ[1..^1]):
            result[a&b] = result.mgetorput(a&b,0) + 1
    func getCounts(pairs: Table[string,int], templ:string):Table[char,int] =
        for p,v in pairs:
            result[p[0]] = result.mgetorput(p[0],0) + v
            result[p[1]] = result.mgetorput(p[1],0) + v
        result[templ[0]] += 1
        result[templ[^1]] += 1
    
    func solve(templ:string, rules:Table[string, char], rounds:int):int =
        var s = prepare(templ)
        for _ in 1..rounds:
            s = s.nxt(rules)
        let c = getCounts(s, templ)
        let d = c.values.toSeq
        (d.max - d.min) div 2
    
    var templ = lines[0]
    var rules:Table[string, char]
    for L in lines[2..^1]:
        let p = L.split(" -> ")
        rules[p[0]] = p[1][0]
        
    part 1: solve(templ, rules, 10)
    part 2: solve(templ, rules, 40)