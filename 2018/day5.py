from aoc import *
from collections import *
from string import ascii_lowercase

def solve(inp):
    part1 = len(react(inp))
    part2 = min(len(react(inp.replace(a, "").replace(a.upper(), ""))) for a in ascii_lowercase)
    return part1, part2

def shorten(poly):
    for a in ascii_lowercase:
        poly = poly.replace(a+a.upper(), "").replace(a.upper()+a, "")
    return poly

def react(poly):
    b, poly = poly, shorten(poly)
    while len(b) != len(poly):
        b, poly = poly, shorten(poly)
    return poly
        
    
run(solve)