include aoc

func toSet(text:string):set[char] =
    for x in text: result.incl x

day 8:
    var data = input.replace("| ","").splitLines.mapIt it.split
    func encode(text:seq[set[char]], digit:int): set[char] =
        case digit
            of 1: return text.filterIt(it.len == 2)[0]
            of 7: return text.filterIt(it.len == 3)[0]
            of 4: return text.filterIt(it.len == 4)[0]
            of 8: return text.filterIt(it.len == 7)[0]
            of 0: return text.filterIt(it.len == 6 and encode(text, 7) <= it and not (encode(text, 4) <= it))[0]
            of 3: return text.filterIt(it.len == 5 and encode(text, 7) <= it)[0]
            of 9: return text.filterIt(it.len == 6 and encode(text, 3) <= it)[0]
            of 6: return text.filterIt(it.len == 6 and encode(text, 9) != it and encode(text, 0) != it)[0]
            of 5: return encode(text, 6) * encode(text, 9)
            of 2: return text.filter(it => all([0,1,3,4,5,6,7,8,9], x => it != encode(text, x)))[0]
            else: return {}
    
    proc decode(text: seq[string], digit:string): int =
        var text2 = text.map toSet
        var digit2 = toSet digit
        for i in 0..9:
            if digit.toSet == encode(text2, i):
                return i
    
    proc decode(text: seq[string], digit:seq[string]): int =
        for d in digit:
            result = result*10 + decode(text, d)
        
    
    part 1,int:
        for L in data:
            result += L[^4..^1].countIt(it.len in [2,3,4,7])
    part 2,int:
        for L in data:
            result += L.decode L[^4..^1]