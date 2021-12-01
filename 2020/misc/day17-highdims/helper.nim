import math

for n in 0..10:
    for L in 0..n:
        for R in 0..n-L:
            echo("(n, L, R) = ", (n,L,R), " c = ", binom(n,L)*binom(n-L,R))