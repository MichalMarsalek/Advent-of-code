import aoc
import tables, math

func modpow(base, exp, modulus: int): int =
    if exp < 0:
        let inverse = modpow(base, modulus - 2, modulus)
        if (base * inverse) mod modulus == 1:
            return modpow(inverse, -exp, modulus)
    result = 1
    var a = base
    var b = exp
    while b > 0:
        if b mod 2 == 1:
            result = (result * a) mod modulus
        a = (a * a) mod modulus
        b = b shr 1

func dlog(base, val, modulus: int): int =
    let m = sqrt(modulus.float).ceil.int
    var lookup = initTable[int, int]()
    var y = 1
    for j in 0..<m:
        lookup[y] = j
        y = (y * base) mod modulus
    let amm = modpow(base, -m, modulus)
    y = val
    for i in 0..<m:
        if y in lookup:
            return i*m + lookup[y]
        y = (y * amm) mod modulus

func solve*(input:string): int =
    let modulus = 20201227
    let data = input.parseInts
    let a = data[0]
    let b = data[1]
    let x = dlog(7,b,modulus)
    return modpow(a,x, modulus)