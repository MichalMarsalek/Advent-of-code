include aoc

day 18:
    ## 
    type NodeRef = ref object
        ## Snailfish number type
        value: int
        left, right: NodeRef
    
    func newNode(val:int): NodeRef =
        ## Returns a new regular number (leaf node)
        result = new(NodeRef)
        result.value = val
    func newNode(left, right: NodeRef): NodeRef =
        ## Returns a new snailfish number composed of the given two parts.
        result = new(NodeRef)
        result.left = left
        result.right = right
    
    func `$`(x:NodeRef):string =
        ## Returns a string representation of the snailfish number. Needed just for debugging.
        if x == nil: return "nil"
        if x.left == nil: return $x.value
        return ("[" & $x.left & "," & $x.right & "]")
    
    func parse(data: string): NodeRef =
        ## Returns the root node of the snailfish number
        ## represented by the given string
        var i = 0
        proc scanNumber(): int =
            while data[i] in Digits:
                result = result * 10 + data[i].ord - '0'.ord
                inc i
    
        proc parse0(): NodeRef =
            if data[i] == '[':
                inc i
                let left = parse0()
                inc i
                let right = parse0()
                inc i
                return newNode(left, right)
            else:
                return newNode scanNumber()
        return parse0()
    
    proc toExplode(number: NodeRef):bool =
        ## Performs the explode operation on the given snailfish number.
        ## Returns true iff the explosion happened.
        
        ## Last node encountered. When depth 4 pair is encountered
        ## the left number is to be added to this node-
        var lastLeft:NodeRef = nil
        
        ## The right value of the depth 4 pair or -1 at start.
        ## When any next regular value is encounter this is to be added to it.
        var explodedRight = -1        
        
        ## Indicates whether explodedRight was already added to some node.
        var explodedPlaced = false
        
        proc traverse(number: NodeRef, depth = 0) =
            if explodedPlaced: return
            if depth == 4 and number.left != nil and explodedRight == -1:
                if lastLeft != nil: lastLeft.value += number.left.value
                explodedRight = number.right.value
                number.left = nil
                number.right = nil
                number.value = 0
                return
            if explodedRight == -1:
                if number.left == nil:
                    lastLeft = number
            else:
                if number.left == nil:
                    number.value += explodedRight
                    explodedPlaced = true
            if number.left != nil:
                traverse(number.left, depth+1)
                traverse(number.right, depth+1)
        traverse number
        return explodedRight > -1
    
    proc toSplit(number: NodeRef): bool =
        ## Performs the split operation on the given snailfish number.
        ## Returns true iff the splitting happened.
        var done = false
        proc traverse(number: NodeRef) =
            if done: return
            if number.left == nil and number.value >= 10:
                done = true
                number.left = newNode(number.value div 2)
                number.right = newNode(number.value - number.value div 2)
            elif number.left != nil:
                traverse number.left
                traverse number.right
        traverse number
        return done
    
    proc toReduce(number: NodeRef) =
        ## Iterates the explode and split operations until nothing changes.        
        while true:
            if toExplode(number): continue
            if not toSplit(number): break
    
    func `+`(a,b: NodeRef): NodeRef =
        ## Adds two snailfish numbers.
        result = newNode(deepcopy a, deepcopy b)
        toReduce result
    
    func magnitude(a: NodeRef): int =
        ## Calculates the magnitude of a snailfish number.
        if a.left == nil: return a.value
        return 3*a.left.magnitude + 2*a.right.magnitude
    
    let numbers = lines.map(parse)
    part 1:
        return magnitude numbers.foldl(a + b)
    part 2,int:
        for i,a in numbers:
            for j,b in numbers:
                if i != j:
                    result = max(result, magnitude(a+b))