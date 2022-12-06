include aoc

day 6:
    func findMarker(data: string, length: Natural): Natural =
        while data[result..<result+length].deduplicate.len < length:
            result += 1
        result + length
    part 1: findMarker(input, 4)
    part 2: findMarker(input, 14)
