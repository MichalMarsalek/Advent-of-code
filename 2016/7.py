from aoc import *

def solve(inp):
    part1 = sum(tls(ip) for ip in inp.splitlines())
    part2 = sum(ssl(ip) for ip in inp.splitlines())
    return part1, part2

def tls(ip):
    parts = ip.replace("]", "[").split("[")
    return any(abba(part) for part in parts[0::2]) and not any(abba(part) for part in parts[1::2])

def abba(text):
    for a, b, c, d in zip(text, text[1:], text[2:], text[3:]):
        if b != a and b == c and d == a:
            return True
    return False

def ssl(ip):
    parts = ip.replace("]", "[").split("[")
    for part in parts[0::2]:
        for a, b, c in zip(part, part[1:], part[2:]):
            if a != b and a == c:
                if any((b+a+b) in part2 for part2 in parts[1::2]):
                    return True
    return False

run(solve)