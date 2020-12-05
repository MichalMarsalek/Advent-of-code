from aoc import *

def solve(inp):
    nums = [int(x) for x in inp]
    part1 = 0
    for x, y in zip(nums, nums[1:]+[nums[-1]]):
        if x == y:
            part1 += x
    part2 = 0
    for i in range(len(nums)):
        if nums[i] == nums[(i + len(nums)//2) % len(nums)]:
            part2 += nums[i]
    
    return part1, part2


run(solve)