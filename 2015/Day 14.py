def solve(input):
    input = input.replace("can fly ","").replace(" km/s for","").replace(" seconds, but then must rest for","").replace(" seconds.","")
    reindeers = [x.split(" ") for x in input.split("\n")]
    states = {name: [0,0,0,0] for name,_,_,_ in reindeers}
    print(reindeers)
    for sec in range(2503):
        for name, speed, limit, rest in reindeers:
            if states[name][1] < int(limit):
                states[name][0] += int(speed)
                states[name][1] += 1
            elif states[name][2] < int(rest) - 1:
                states[name][2] += 1
            else:
                states[name][1] = states[name][2] = 0
        max_dist = max(states[name][0] for name in states)
        for name in states:
            states[name][3] += states[name][0] == max_dist
        print(sec, states)
    part1 = max([states[state][0] for state in states])
    part2 = max([states[state][3] for state in states])
    return part1, part2
    
def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(14)
