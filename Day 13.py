from itertools import permutations

def solve(input):
    input = input.replace(" would", "").replace("lose ", "-").replace("gain ", "").replace("happiness units by sitting next to ", "").replace(".", "")
    lines = [x.split(" ") for x in input.split("\n")]
    relations = {}
    for person, happiness, neighbor in lines:
        if person not in relations:
            relations[person] = {}
        relations[person][neighbor] = int(happiness)
    part1 = find(relations)
    relations["Me"] = {}
    for person in relations.keys():
        relations[person]["Me"] = 0
        relations["Me"][person] = 0
    part2 = find(relations)
    return part1, part2

def find(relations):
    people = list(relations.keys())
    arrangements = [[people[0]] + list(arr) for arr in permutations(people[1:])]
    return max(arr_value(arr, relations) for arr in arrangements)

def arr_value(arr, relations):
    happiness = 0
    for i in range(len(arr)):
        happiness += relations[arr[i]][arr[i-1]]
        happiness += relations[arr[i]][arr[(i+1)%len(arr)]]
    return happiness

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(13)
