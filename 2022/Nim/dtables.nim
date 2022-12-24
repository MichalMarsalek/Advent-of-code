import tables

type DTable*[K, V] = object
    table*: Table[K, V] # this should idealy be private but I want to keep it public for quick hacking when solving AoC
    default*: V

func `$`*(a: DTable): string = $a.table

func `$`*(a, b: DTable): bool = a.table == b.table

func `[]`*[A, B](t: var DTable[A, B], key: A): var B = t.table.mgetOrPut(key, t.default)

proc `[]=`*[A, B](t: var DTable[A, B]; key: A; val: sink B) = t.table[key] = val

func contains*[A, B](t: DTable[A, B]; key: A): bool = t.table.contains key

func hasKey*[A, B](t: DTable[A, B]; key: A): bool = t.table.hasKey key

func initDTable*[A, B](def = default(B), initialSize = defaultInitialSize): DTable[A, B] =
    result.table = initTable(initialSize)
    result.default = def

func len*[A, B](t: DTable[A, B]): int = t.table.len

func toDTable*[A, B](pairs: openArray[(A, B)]): DTable[A, B] =
    result.table = pairs.toTable

func toDTable*[A, B](t: Table[A, B]): DTable[A, B] =
    result.table = t

iterator keys*[A, B](t: DTable[A, B]): lent A =
    for k in t.table.keys: yield k

iterator pairs*[A, B](t: DTable[A, B]): (A, B) =
    for k, v in t.table: yield (k, v)

iterator values*[A, B](t: DTable[A, B]): (A, B) =
    for v in t.table.values: yield v

