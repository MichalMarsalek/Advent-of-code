c = 8400+117000
b = 8400+100000
h = 0
while b != c:
    f = 1
    d = 2
    while d != b:
        e = 2
        if b % d == 0:
            f = 0
            break
        d += 1
    if f == 0:
        h += 1
    b += 17    
print(h)
