import math

var emptyOptions = 0
for a in 0..4:
    for b in 0..min(4,7-a):
        for c in 0..min(4,7-a-b):
            for d in 0..min(4,7-a-b-c):
                emptyOptions += binom(7,a+b+c+d)
echo 16.fac div 4.fac^4 * emptyOptions