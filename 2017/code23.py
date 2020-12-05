c = 8400+117000
b = 8400+100000
h = 0
while b != c:
    print(b)
    f = 1
    d = 2
    g = 1
    while d != b:
        e = 2
        while e != b:
            if d*e == b:
                f = 0
                break
            e += 1
        if f == 0:
            break
        d += 1
    if f == 0:
        h += 1
    b += 17    
print(h)
