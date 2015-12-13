import itertools

def solve(input):
    lines = [line.split(" ") for line in IN.replace(" =", "").replace(" to", "").split("\n")]
    roads = {frozenset((city1, city2)) : int(dist) for city1, city2, dist in lines}
    cities = set(city1 for city1, city2, dist in lines) | set(city2 for city1, city2, dist in lines)
    routes = itertools.permutations(cities)
    chains = [zip(route, route[1:]) for route in routes]
    lengths = [sum(roads[frozenset(road)] for road in chain) for chain in chains]
    part1 = min(lengths)
    part2 = max(lengths)
    return part1, part2
    
def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(9)