# My solutions to AoC in Nim

I created a simple template setup that allows me to reduce the boiler plate. I'll demonstrate its usage on the solution of day 1:

```nim
include aoc

day(1):
    part1:
        zip(ints, ints[1..^1]).filterIt(it[1]>it[0]).len
    part2:
        zip(ints, ints[3..^1]).filterIt(it[1]>it[0]).len
```

or

```nim
include aoc

day(1):
    proc solve(offset:int):int =
        zip(ints, ints[offset..^1]).filterIt(it[1]>it[0]).len
    part1: solve 1
    part2: solve 3
```
both work equally well.  
Each `day` block defines a function `string --> (string, string)` that on given input solves both parts. Furthermore, if `isMainModule` it downloads the input (unless it is already present on disk), calls the solution on the input and prints the two results.
The input is implicit in an injected `input` variable as well as in `ints` variable (which comprises of parsed integers present anywhere in the input) and `intgrid` variable (matrix of ints).  
The solution function is also stored in `SOLUTIONS[day]`.  
Instead of `part1:` you can do `part(int)` and specify the output type of the part. This is useful because it gives you an autoinitialized `result`.
The `aoc` module apart from implementing these templates, includes `prelude`, `algorithm` and `math`.
The substitution goes something like this:

```nim
day(k):
    someCommonCode
    part1: solution1
    part2: solution2
```
transforms into
```nim
SOLUTIONS[k] = proc (input: string): (string, string) =
    someCommonCode
    proc part1(): auto =
        solution1
    proc part2(): auto =
        solution2
    return ($part1(), $part2())
echo SOLUTIONS[k](getInputForDay(k))
```
