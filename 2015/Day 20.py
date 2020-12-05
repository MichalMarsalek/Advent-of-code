def solve(input):
    part1 = 0#solve1(input)
    part2 = solve2(input)
    return part1, part2

def solve1(input):
    input = int(input) // 10
    house = 830000
    i = 1
    while i <= 10000:
        suma = sum_all_factors(prime_factors(house))
        if suma > input:
            return house
        house += 2
        i += 1

def solve2(input):
    input = int(input)
    house = 882000
    i = 1
    while i < 1500:
        suma = 0
        for elf in range(1, house + 1):
            if house % elf or elf * 50 < house:
                continue
            suma += elf * 11
        if suma > 34000000:
            print(house, suma)
        if suma >= input:
            break
        house += 2
        i += 1
    return house

def prime_factors(n):
    factors = {}
    i = 2
    while n > 1:
        if n % i == 0:
            n = n // i
            if i in factors:
                factors[i] += 1
            else:
                factors[i] = 1
        else:
            i += 1 + i > 2
    return factors

def sum_all_factors(factors):
    total = 1
    for factor, count in factors.items():
        total *= sum(factor ** power for power in range(count + 1))
    return total

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(20)
