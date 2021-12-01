import strutils, strformat, times
import day1, day2, day3, day5, day6, day23, day25

var INPUTS, OUTPUTS: array[1..25, string]
for day in 1..25:
    INPUTS[day] = readFile(fmt"inputs\\day{day}.in").strip

#var SOLVERS: array[3, proc (x:string):(string, string)] = [day1.solve, day2.solve, day3.solve]

let start = cpuTime()
#for day in 1..3:
#    OUTPUTS[day] = $SOLVERS[day](INPUTS[day])
#OUTPUTS[1] = $day1.solve(INPUTS[1])
#OUTPUTS[2] = $day2.solve(INPUTS[2])
#OUTPUTS[3] = $day3.solve(INPUTS[3])
#for _ in 1..1000:
#    OUTPUTS[5] = $day5.solve(INPUTS[5])
#OUTPUTS[6] = $day6.solve(INPUTS[6])
#OUTPUTS[23] = $day23.solve(INPUTS[23])
for _ in 1..1000:
    OUTPUTS[25] = $day25.solve(INPUTS[25])
echo "Time taken: ", (cpuTime()-start)
echo ""
echo OUTPUTS
    