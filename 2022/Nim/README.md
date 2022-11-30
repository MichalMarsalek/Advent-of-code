# My solutions to AoC in Nim

I created a simple template setup that allows me to reduce the boiler plate. I'll demonstrate its usage on the solution of day 1 of 2021:

```nim
include aoc

day 1:
    part 1:
        zip(ints, ints[1..^1]).countIt it[1]>it[0]
    part 2:
        zip(ints, ints[3..^1]).countIt it[1]>it[0]
```

or

```nim
include aoc

day 1:
    proc solve(offset:int):int =
        zip(ints, ints[offset..^1]).countIt it[1]>it[0]
    part 1: solve 1
    part 2: solve 3
```
both work equally well.  
Each `day` block defines a function `string --> Table[int, string]` that on given input solves both parts. Furthermore, if `isMainModule` it downloads the input (unless it is already present on disk), calls the solution on the input and prints the results.
The input is implicit in an injected `input` variable as well as in `ints` variable (which comprises of parsed integers present anywhere in the input).  
The solution function is also stored in `SOLUTIONS[day]`.  
Instead of `part 1:` you can do `part 1,int` and specify the output type of the part. This is useful because it gives you an autoinitialized `result`. Parts other than 1 and 2 are supported.
The `aoc` module apart from implementing these templates, includes `prelude`, `algorithm, sugar, strscans` and `math`.
On a high level, the substitution goes something like this:

```nim
day k:
    someCommonCode
    part 1: solution1
    part 2: solution2
```
transforms into
```nim
SOLUTIONS[k] = proc (input: string): Table[int, string] =
    someCommonCode
    proc part1(): auto =
        solution1
    proc part2(): auto =
        solution2
    return {1: $part1(), 2: $part2()}.toTable
echo SOLUTIONS[k](getInputForDay(k))
```