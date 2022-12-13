include aoc

day 12:
    func elevation(x: char): int =
        if x == 'S': ord('a')
        elif x == 'E': ord('z')
        else: ord(x)
    let terrain = lines.mapIt(toSeq it)
    let start = terrain.coordinates.toSeq.filterIt(terrain[it] == 'S')[0]
    let finish = terrain.coordinates.toSeq.filterIt(terrain[it] == 'E')[0]
    let distancesToFinish = terrain.neighboursRec(finish, (a, b) => elevation(a)-elevation(b) <= 1)
    part 1:
        distancesToFinish[start]
    part 2:
        terrain.coordinates.toSeq.filterIt(terrain[it] == 'a').mapIt(distancesToFinish.getOrDefault(it, int.high)).min
