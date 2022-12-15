include aoc
import rectangles

day 15:
    let data = lines.map(ints4).mapTuple ((a, b), (c, d))
    proc findImpossibleOnRow(rowY: int, includeKnown: bool): RectangleUnion[range[0..0]] =
        for (s, b) in data:
            let dist = dist1(s, b)
            let width = dist - abs(rowY - s.y)
            if width > 0:
                result += [s.x - width] ^> [s.x + width]
        if not includeKnown:
            for (_, b) in data:
                if b.y == rowY:
                    result -= [b.x] ^> [b.x]
    part 1:
        card findImpossibleOnRow(2000000, false)
    part 2, int:
        for y in 0..4000000:
            let possible = [0] ^> [4000000] - findImpossibleOnRow(y, true)
            if card(possible) > 0:
                return y + 4000000 * possible.rectangles[0][0][0]
