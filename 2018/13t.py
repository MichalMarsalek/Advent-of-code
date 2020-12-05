from aoc import *
from collections import *

def solve(inp):
  lines = inp.splitlines()

  track = [
    l.replace('>', '-').replace('<', '-').replace('^', '|').replace('v', '|')
    for l in lines
  ]

  # carts stores (y, x, ch, k) where ch is the current character for that
  # cart (indicating its direction) and k reflects its left/straight/right
  # memory as a number 0 through 2. (Sorting this list using natural order
  # produces the correct order for processing.)
  carts = []
  for y, l in enumerate(lines):
    for m in re.finditer(r'[<>v\^]', l):
      carts.append((y, m.start(), m.group(0), 0))

  part1done = False
  while True:
    crashed = set()
    for i in range(len(carts)):
      (y, x, ch, k) = carts[i]
      if (y, x) in crashed:
        continue
      if ch == '>':
        n = (y, x + 1)
      elif ch == '<':
        n = (y, x - 1)
      elif ch == '^':
        n = (y - 1, x)
      elif ch == 'v':
        n = (y + 1, x)
      (ny, nx) = n
      if any(ay == ny and ax == nx for (ay, ax, ac, ak) in carts):
        if not part1done:
          print('%d,%d' % (nx, ny))
          part1done = True
        crashed.add(n)
      if track[ny][nx] in '\\/':
        ch = {
          '>\\': 'v',
          '<\\': '^',
          '^\\': '<',
          'v\\': '>',
          '>/': '^',
          '</': 'v',
          '^/': '>',
          'v/': '<',
        }[ch + track[ny][nx]]
      elif track[ny][nx] == '+':
        ch = {
          '>0': '^',
          '>1': '>',
          '>2': 'v',
          '<0': 'v',
          '<1': '<',
          '<2': '^',
          '^0': '<',
          '^1': '^',
          '^2': '>',
          'v0': '>',
          'v1': 'v',
          'v2': '<',
        }[ch + str(k)]
        k = (k + 1) % 3
      carts[i] = (ny, nx, ch, k)
    else:
      carts = [c for c in carts if (c[0], c[1]) not in crashed]
      if len(carts) == 1:
        print('%d,%d' % (carts[0][1], carts[0][0]))
        break
      carts.sort()
      continue
    break


run(solve, 13, True)