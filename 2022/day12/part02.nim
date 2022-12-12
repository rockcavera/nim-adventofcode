const
  width = 136
  hight = 41

type
  Xy = object
    elevation: int
    used: bool

  Map = array[hight, array[width, Xy]]

  Coordinate = object
    x, y: int

  Movements = enum
    Up, Down, Left, Right

  NodeObj = object
    pos: Coordinate
  Node = ref NodeObj

  NodeList = object
    tail: Node
    heads: seq[Node]

proc newNode(pos: Coordinate): Node =
  new(result)
  result.pos = pos

proc makeMap(map: var Map, cp, bs: var Coordinate) =
  var
    x = 0
    y = 0

  for l in lines("input.txt"):
    if l == "":
      continue

    for c in l:
      case c
      of { 'a' .. 'z' }:
        map[y][x].elevation = ord(c) - static(ord('a'))
      of 'S':
        map[y][x].elevation = 0
        cp.x = x
        cp.y = y
      of 'E':
        map[y][x].elevation = static(ord('z') - ord('a'))
        bs.x = x
        bs.y = y
      else:
        discard

      inc(x)

    x = 0

    inc(y)

proc `==`(a, b: Coordinate): bool =
  (a.x == b.x) and (a.y == b.y)

proc seekBetterRoute(map: Map, ip, bs: Coordinate): int =
  var
    map = map
    route: NodeList

  map[ip.y][ip.x].used = true
  route.tail = newNode(ip)
  route.heads = @[route.tail]

  block arrivedAtTheBestSignal:
    while len(route.heads) > 0:
      inc(result)

      var newHeads = newSeqOfCap[Node](3 * len(route.heads)) # Four possible movements from the tail

      for head in route.heads:
        for move in Movements:
          var np = head.pos

          case move
          of Up:
            dec(np.y)
          of Down:
            inc(np.y)
          of Left:
            dec(np.x)
          of Right:
            inc(np.x)

          if np.x >= 0 and np.x < width and np.y >= 0 and np.y < hight: # check if it is within map boundaries
            if not map[np.y][np.x].used: # check if it has already passed that coordinate
              let diff = map[head.pos.y][head.pos.x].elevation - map[np.y][np.x].elevation
              if diff == -1 or diff >= 0: # check if it is possible to go up or down the elevation
                if np == bs: # check if it arrived at the best signal
                  break arrivedAtTheBestSignal

                map[np.y][np.x].used = true

                add(newHeads, newNode(np))

      route.heads = newHeads

    result = high(int) # cannot find route to E

var
  map: Map
  currentPos, bestSignal: Coordinate
  bestRoute = high(int)

makeMap(map, currentPos, bestSignal)

for y in 0 ..< hight:
  for x in 0 ..< width:
    if map[y][x].elevation == 0:
      let a = seekBetterRoute(map, Coordinate(x: x, y: y), bestSignal)

      if a < bestRoute:
        bestRoute = a

echo "Answer: ", bestRoute
