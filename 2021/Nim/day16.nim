include aoc

day 16:   
    type Packet = object
        version: int
        typeID: int
        value: int
        children: seq[Packet]
    
    proc scanNumber(stream: var string, length: int): int =
        for _ in 1..length:
            result = result * 2 + parseInt($stream[0])
            stream = stream[1..^1]
    proc parse(data: string): Packet =
        proc parse0(stream: var string): Packet =
            result.version = stream.scanNumber(3)
            result.typeID = stream.scanNumber(3)
            result.children = @[]
            if result.typeID == 4:
                while true:
                    let temp = stream.scanNumber(5)
                    if temp >= 16:
                        result.value = result.value * 16 + temp - 16
                    else:
                        result.value = result.value * 16 + temp
                        break
            else:
                let lengthType = stream.scanNumber(1)
                if lengthType == 0: 
                    let bitLength = stream.scanNumber(15)
                    let targetLength = stream.len - bitLength
                    while stream.len > targetLength:
                        result.children.add stream.parse0
                else:
                    let packetCount = stream.scanNumber(11)
                    while result.children.len < packetCount:
                        result.children.add stream.parse0
        var bits = ""
        for c in input:
            bits &= parseHexInt($c).toBin(4)
        return parse0 bits
    
    var p1 = 0
    proc eval(packet: Packet): int =
        p1 += packet.version
        let children = packet.children.map(eval)
        return case packet.typeID
        of 0: children.sum
        of 1: children.prod
        of 2: children.min
        of 3: children.max
        of 4: packet.value
        of 5: int(children[0] >  children[1])
        of 6: int(children[0] <  children[1])
        else: int(children[0] == children[1])
    
    let top = parse input
    let p2 = eval top
    part 1: p1        
    part 2: p2