import aoc

solution:
    let numbers = input.column
    part1:
        for i in 0..<numbers.len:
            for j in i<..numbers.len:
                if numbers[i] + numbers[j] == 2020:
                    return numbers[i] * numbers[j]
    part2:
        for i in 0..<numbers.len:
            for j in i<..numbers.len:
                for k in j<..numbers.len:
                    if numbers[i] + numbers[j] + numbers[k] == 2020:
                        return numbers[i] * numbers[j] * numbers[k]
                