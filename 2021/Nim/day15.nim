include aoc
import heapqueue

# Dijkstra algorithm from rosettacode
 
from algorithm import reverse
import sets
import strformat
import tables
 
type
  Edge = tuple[src, dst: string; cost: int]
  Graph = object
    vertices: HashSet[string]
    neighbours: Table[string, seq[tuple[dst: string, cost: float]]]
 
#---------------------------------------------------------------------------------------------------
 
proc initGraph(edges: openArray[Edge]): Graph =
  ## Initialize a graph from an edge list.
  ## Use floats for costs in order to compare to Inf value.
 
  for (src, dst, cost) in edges:
    result.vertices.incl(src)
    result.vertices.incl(dst)
    result.neighbours.mgetOrPut(src, @[]).add((dst, cost.toFloat))
 
#---------------------------------------------------------------------------------------------------
 
type vert = (string, int)
proc `<`(a, b: vert): bool = a[1] < b[1]


proc dijkstraPath(graph: Graph; first, last: string): int =
  ## Find the path from "first" to "last" which minimizes the cost.
 
  var dist = initTable[string, float]()
  var previous = initTable[string, string]()
  var notSeen = graph.vertices
  var q = [(first,0)].toHeapQueue
  for vertex in graph.vertices:
    dist[vertex] = Inf
  dist[first] = 0
 
  while q.len > 0:
    # Search vertex with minimal distance.
    var vertex1 = q.pop[0]
    if vertex1 == last:
      break
    notSeen.excl(vertex1)
    # Find shortest paths to neighbours.
    for (vertex2, cost) in graph.neighbours.getOrDefault(vertex1):
      if vertex2 in notSeen:
        let altdist = dist[vertex1] + cost
        if altdist < dist[vertex2]:
          # Found a shorter path to go to vertex2.
          dist[vertex2] = altdist
          previous[vertex2] = vertex1    # To go to vertex2, go through vertex1.
          q.push (vertex2, dist[vertex2].int)
  return dist[last].int
 
#---------------------------------------------------------------------------------------------------
 
proc printPath(path: seq[string]) =
  ## Print a path.
  stdout.write(fmt"Shortest path from '{path[0]}' to '{path[^1]}': {path[0]}")
  for i in 1..path.high:
    stdout.write(fmt" → {path[i]}")
  stdout.write('\n')

#proc pricePath(graph:Graph, path: seq[string]):int =
  
 
 
#---------------------------------------------------------------------------------------------------

day 15:   
    let grid = lines.map(L => L.mapIt(parseInt $it))
    
    part 1:
        var edges: seq[(string,string,int)]
        for (x,y) in grid.coordinates:
            for (X,Y) in grid.neighbours((x,y)):
                edges.add ($(y*grid.len + x), $(Y*grid.len + X), grid[X,Y])
        let graph = initGraph(edges)
        graph.dijkstraPath($0, $(grid.size-1))
    part 2:
        var grid2: seq[seq[int]]
        for i in 0..4:
            for r in grid:
                grid2.add r.mapIt((it + i + 8)mod 9 + 1)&r.mapIt((it + i + 0)mod 9 + 1)&r.mapIt((it + i + 1)mod 9 + 1)&r.mapIt((it + i + 2)mod 9 + 1)&r.mapIt((it + i + 3)mod 9 + 1)
        var edges: seq[(string,string,int)]
        for (x,y) in grid2.coordinates:
            for (X,Y) in grid2.neighbours((x,y)):
                edges.add ($(y*grid2.len + x), $(Y*grid2.len + X), grid2[X,Y])
        let graph = initGraph(edges)
        graph.dijkstraPath($0, $(grid2.size-1))