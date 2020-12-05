def solve(input):
    grid1 = [[char == "#" for char in line] for line in input.split("\n")]
    grid2 = [line[:] for line in grid1]
    for i in range(100):
        grid1 = next_gen(grid1)
        grid2 = next_gen(grid2, [(0,0), (len(grid2[0]) - 1, 0), (0, len(grid2) - 1), (len(grid2[0]) - 1, len(grid2) - 1)])
    part1 = sum(map(sum, grid1))
    part2 = sum(map(sum, grid2))
    return part1, part2

def next_gen(old, stucks = []):
    new = [line[:] for line in old]
    for y, line in enumerate(old):
        for x, light in enumerate(line):
            if (x, y) in stucks:
                new[y][x] = True
                continue
            neigs = neigbors(old, x, y)
            if light:
                new[y][x] = neigs in (2,3)
            else:
                new[y][x] = neigs == 3
    return new

def neigbors(grid, x, y):
    def cell(grid, x, y):
        return 0 if x < 0 or y < 0 or y >= len(grid) or x >= len(grid[0]) else grid[y][x]
    return sum(cell(grid, X, Y) for X in range(x-1, x+2) for Y in range(y-1, y+2) if x != X or y != Y)

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(18)