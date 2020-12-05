import time
start_time = time.time()

def solve(input):
    ingredients = {name: {prop: int(val) for prop, val in [y.split() for y in props.split(", ")]} for name, props in [x.split(": ") for x in input.split("\n")]}    
    print(ingredients)
    recipe_base = {ingred: None for ingred in ingredients.keys()}
    recipes = find_recipes(recipe_base, 300)
    print(len(recipes))    
    part1 = max(score(ingredients, recipe) for recipe in recipes)
    part2 = max(score(ingredients, recipe, 500) for recipe in recipes)
    return part1, part2

def find_recipes(ingreds, spoons, calories = None):
    unknown = [ingred for ingred in ingreds if ingreds[ingred] is None]
    if len(unknown) == 0:
        return [ingreds]
    ingred = unknown[0]
    ingreds2 = dict(ingreds)
    recipes = []
    limit = spoons - len(unknown) + 1
    for i in range(limit if len(unknown) == 1 else 1, limit + 1):
        ingreds2[ingred] = i
        recipes.extend(find_recipes(ingreds2, spoons - i))
    return recipes

def score(ingredients, recipe, calories = None):
    props_scores = 1
    for prop in list(ingredients.values())[0]:
        if prop == "calories" and calories is None:
            continue            
        suma = sum(recipe[ingred] * ingredients[ingred][prop] for ingred in ingredients)
        if suma <= 0:
            return 0
        if prop == "calories" and calories is not None:
            if suma != calories:
                return 0
            continue
        props_scores *= suma
    return props_scores

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(15)

print("--- %s seconds ---" % (time.time() - start_time))