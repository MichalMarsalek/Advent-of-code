from aoc import *

def solve(inp):
    data = []
    for line in inp.splitlines():
        i, a = line[:-1].replace(",", "").split(" (contains ")
        data.append((i.split(), a.split()))
    allergen_to_ingredients = {}
    ing_list = []
    for ingredients, allergens in data:
        for a in allergens:
            if a in allergen_to_ingredients:
                allergen_to_ingredients[a] &= set(ingredients)
            else:
                allergen_to_ingredients[a]  = set(ingredients)
        ing_list.extend(ingredients)
    safe = []
    for i in set(ing_list):
        if i not in set.union(*allergen_to_ingredients.values()):
            safe.append(i)
    part1 = sum(ing_list.count(i) for i in safe)
    placed = set()
    while len(placed) < len(allergen_to_ingredients):
        for ii in allergen_to_ingredients.values():
            if len(ii) == 1:
                placed |= ii
        allergen_to_ingredients = {k:(v if len(v) == 1 else v - placed) for k,v in allergen_to_ingredients.items()}
    part2 = ",".join(list(v)[0] for k,v in sorted(allergen_to_ingredients.items()))
    return part1, part2

run(solve)