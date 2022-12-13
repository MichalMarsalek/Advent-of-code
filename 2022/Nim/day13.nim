include aoc
import json

day 13:
    func cmp(a, b: JsonNode): int =
        if a.kind == JInt and b.kind == JInt:
            return cmp(a.getInt, b.getInt)
        let aChildren = if a.kind == JArray: a.elems else: @[a]
        let bChildren = if b.kind == JArray: b.elems else: @[b]

        for (a, b) in zip(aChildren, bChildren):
            let c = cmp(a, b)
            if c != 0: return c
        return cmp(aChildren.len, bChildren.len)

    part 1:
        let pairs = input.split("\n\n").mapIt(it.splitLines.mapIt it.parseJson).mapIt (it[0], it[1])
        sum(
            for i, (a, b) in pairs:
                if cmp(a, b) < 0:
                    i+1
        )

    part 2:
        var data = (lines & "[[2]]" & "[[6]]").filterIt(it != "").mapIt it.parseJson
        sort(data, cmp)
        prod:
            collect:
                for i, x in data:
                    if $x in ["[[2]]", "[[6]]"]:
                        i+1
