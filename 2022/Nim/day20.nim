include aoc

day 20:
    func wrap(data: seq[int]): seq[Point] = toSeq pairs data

    func unwrap(data: seq[Point]): seq[int] = data.mapTuple b

    func mix(data: seq[Point], order: seq[Point] = data): seq[Point] =
        let n = data.len
        result = data
        for (j, x) in order:
            let a = result.find (j, x)
            let q = abs(x) mod (n-1)
            for i in 0..<q:
                swap result[(a + i * sgn(x)).floorMod n], result[(a + (i+1) * sgn(x)).floorMod n]

    func groveSum(data: seq[int], indeces = @[1000, 2000, 3000]): int =
        let n = data.len
        let zero = data.find 0
        indeces.mapIt(data[(zero + it).floorMod n]).sum

    part 1: groveSum unwrap mix wrap integers
    part 2:
        const key = 811589153
        let integers2 = integers.mapIt it * key
        proc mixWithOrder(x: seq[Point]): seq[Point] = x.mix(wrap integers2)
        groveSum unwrap (mixWithOrder^10)wrap integers2
