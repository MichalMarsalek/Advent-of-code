from hashlib import md5

def h(n):
    r = "23769"
    for i in range(2017):
        r = md5((r + str(n)).encode()).hexdigest()
    return r
open("hashes2.txt", "w").write("\n".join(h(n) for n in range(50000)))
    