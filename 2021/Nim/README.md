# My solutions to AoC in Nim

I created a simple template setup that allows me to reduce the boiler plate. I'll demonstrate its usage on the solution of day 1:

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
        zip(ints, ints[offset..^1])countIt it[1]>it[0]
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

## Fast solutions
Apart from the general solutions I try to write separate speedy solutions (fast.nim).
As is usual, I measure the time time it takes for a function which takes the input as a string a returns two strings representing the answer to return. Measuring how long it takes the OS to start the program or how long it takes the harddisk to read the input is kind of random and totally uninteresting to me. Each day is evaluated 10000 times.

Output for day 13 part 2 is the ASCII art letters.

| Day             	| Mean time        	|
|-----------------	|---------------	|
| 1              	| 0.046 ms       	|
| 2              	| 0.001 ms       	|
| 3              	| 0.032 ms       	|
| 4              	| 0.165 ms       	|
| 5              	| 1.615 ms       	|
| 6              	| 0.001 ms       	|
| 7              	| 0.028 ms       	|
| 8              	| 0.052 ms       	|
| 9              	| 0.162 ms       	|
| 10              	| 0.026 ms       	|
| 11              	| 0.113 ms       	|
| 12              	| 0.174 ms       	|
| 13              	| 0.215 ms       	|

Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz   2.70 GHz
