h = 0
for b in range(8400+100000, 8400+117000+17, 17):
    for d in range(2, b):
        if b % d == 0:
            h += 1
            break
print(h)
        
