import itertools
import time

start_time = time.time()
last_time = start_time

def solve(input):
    presents = sorted(int(x) for x in input.split("\n"))[::-1]
    """print("SUM", sum(presents) // 3)
    print("GROUP1 solving:")
    ways = get_ways3(presents)
    print("WAYS", len(ways))
    part1 = min(qe(way[0]) for way in ways)"""
    part1 = 0
    print("SUM", sum(presents) // 3)
    print("GROUP1 solving:")
    ways = get_ways4(presents)
    print("WAYS", len(ways))
    part2 = min(qe(way[0]) for way in ways)
    return part1, part2

def qe(group):
    product = 1
    for a in group:
        product *= a
    return product

def get_ways3(presents):
    goal = sum(presents) // 3
    ways = set()
    group1s = get_groups(presents, goal, 0, [999])
    min_len = min(map(len, group1s))
    group1s = [group1 for group1 in group1s if len(group1) == min_len]
    g_len = len(group1s)
    print("\nNumber of ways for group1", g_len, "\n")
    print("--- %s seconds ---" % (time.time() - start_time))
    for i, group1 in enumerate(group1s):
        print("\nSolving group2 for group1", group1)
        diff = time.time() - start_time
        print("%s/%s, %.2f s => %.2f m" % (i+1, g_len, diff, diff / (i+1) * (g_len - i - 1) / 60))
        rest = list(set(presents) - set(group1))
        group2s = get_groups(rest, goal, 0)
        for group2 in group2s:
            group3 = sorted(list(set(presents) - set(group1) - set(group2)))
            way = (frozenset(group1), frozenset(group2), frozenset(group3))
            ways.add(way)
    return ways

def get_ways4(presents):
    goal = sum(presents) // 4
    ways = set()
    group1s = get_groups(presents, goal, 0, [999])
    min_len = min(map(len, group1s))
    group1s = [group1 for group1 in group1s if len(group1) == min_len]
    g_len = len(group1s)
    print("\nNumber of ways for group1", g_len, "\n")
    print("--- %s seconds ---" % (time.time() - start_time))
    #return set((group1,) for group1 in group1s)
    for i, group1 in enumerate(group1s):
        print("\nSolving group2 for group1", group1)
        diff = time.time() - start_time
        print("%s/%s, %.2f s => %.2f m" % (i+1, g_len, diff, diff / (i+1) * (g_len - i - 1) / 60))
        rest = list(set(presents) - set(group1))
        group2s = get_groups(rest, goal, 0)
        for group2 in group2s:
            rest = list(set(presents) - set(group1) - set(group2))
            group3s = get_groups(rest, goal, 0)
            for group3 in group3s:
                group4 = sorted(list(set(presents) - set(group1) - set(group2)))
                way = (frozenset(group1), frozenset(group2), frozenset(group3), frozenset(group4))
                ways.add(way)
    return ways

def get_groups(presents, goal, r, max_len = None):
    if r == 1 and max_len is not None:
        print("Presents", presents)
    ways = set()
    for i, present in enumerate(presents):
        if present > goal:
            continue
        if present == goal:
            ways.add(frozenset((present,)))
            if max_len is not None:
                max_len[0] = r + 1
        elif max_len is not None and r + 1 > max_len[0]:
            continue
        else:
            subways = get_groups(presents[i+1:], goal - present, r + 1, max_len)
            if subways:
                for subway in subways:
                    ways.add(frozenset((present,)) | subway)
    return ways

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(24)

print("--- %s seconds ---" % (time.time() - start_time))