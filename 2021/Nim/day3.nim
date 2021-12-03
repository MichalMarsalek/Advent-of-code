include aoc

day 3:
    proc common(data: seq[string], least=false):string =
        for i in 0..<data[0].len:
            let common_digit = int(least xor data.mapIt(parseInt($it[i])).sum*2 >= data.len)
            result &= $int(common_digit)
    
    proc common_reduce(data:seq[string], least=false):string =
        var data = data
        var i = 0
        while data.len > 1:
            data = data.filterIt(it[i] == data.common(least)[i])
            inc i
        return data[0]
    
    part 1:
        let most = lines.common
        let least = lines.common(true)
        return parseBinInt(most) * parseBinInt(least)
    part 2:
        let most = lines.common_reduce
        let least = lines.common_reduce(true)
        return parseBinInt(most) * parseBinInt(least)