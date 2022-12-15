import std/[strutils, strscans]

type
  Coordinate = object
    x, y: int

  Objects = enum
    Air, Rock, Sand, Source

  Movements = enum
    Left, Right, Up, Down

proc drawMap(map: seq[seq[Objects]]) {.used.} =
  # Just for debugging
  let
    width = len(map)
    hight = len(map[0])

  var y = 0

  while y < hight:
    var x = 0

    while x < width:
      var print: char

      case map[x][y]
      of Air:
        print = '.'
      of Rock:
        print = '#'
      of Source:
        print = '+'
      of Sand:
        print = 'o'

      write(stdout, print)

      inc(x)

    write(stdout, '\n')
    inc(y)

iterator pointsLine(a, b: Coordinate): Coordinate =
  var
    m = Right
    z = b.x - a.x

  if z < 0:
    m = Left
  elif z == 0:
    m = Down
    z = b.y - a.y

    if z < 0:
      m = Up

  z = abs(z)

  var p = a

  yield p

  for _ in 1 .. z:
    case m
    of Up:
      dec(p.y)
    of Down:
      inc(p.y)
    of Left:
      dec(p.x)
    of Right:
      inc(p.x)

    yield p

func `==`(a, b: Coordinate): bool =
  a.x == b.x and a.y == b.y

proc simulate(map: var seq[seq[Objects]], source: Coordinate): int =
  while true:
    var sand, np = source

    block sandStopped:
      while true:
        inc(np.y) # Down

        if map[np.x][np.y] == Air:
          sand = np
          continue

        dec(np.x) # Left

        if map[np.x][np.y] == Air:
          sand = np
          continue

        inc(np.x, 2) # Right

        if map[np.x][np.y] == Air:
          sand = np
          continue
        else:
          break sandStopped

    map[sand.x][sand.y] = Sand

    inc(result)

    if sand == source:
      break

proc arithmeticProgression(a1, n, r: int): int =
  ## Calculate the term `n` of the arithmetic progression with initial term `a1` and ratio `r`.
  result = a1 + ((n - 1) * r)

const sandSource = Coordinate(x: 500, y: 0)

var
  rocks = newSeqOfCap[seq[Coordinate]](138)
  xMax, xMin = sandSource.x
  yMax, yMin = sandSource.y

for l in lines("input.txt"):
  var cr = newSeqOfCap[Coordinate](25)

  for strC in split(l, " -> "):
    var c: Coordinate

    if scanf(strC, "$i,$i", c.x, c.y):
      add(cr, c)

      if c.x > xMax:
        xMax = c.x
      if c.x < xMin:
        xMin = c.x
      if c.y > yMax:
        yMax = c.y
      if c.y < yMin:
        yMin = c.y

  add(rocks, cr)

yMax += 2

let
  halfTheFloor = ((arithmeticProgression(1, yMax, 2) + 1) div 2)
  xInitFloor = sandSource.x - halfTheFloor
  xEndFloor = sandSource.x + halfTheFloor

if xInitFloor < xMin:
  xMin = xInitFloor
if xEndFloor > xMax:
  xMax = xEndFloor

add(rocks, @[Coordinate(x: xInitFloor, y: yMax), Coordinate(x: xEndFloor, y: yMax)]) # Add floor

let
  width = xMax - xMin + 1
  hight = yMax - yMin + 1

var map = newSeq[seq[Objects]](width)

for x in 0 ..< len(map):
  map[x] = newSeq[Objects](hight)

map[sandSource.x - xMin][sandSource.y - yMin] = Source

for r in rocks:
  var initPoint = r[0]

  for i in 1 .. high(r):
    let endPoint = r[i]

    for p in pointsLine(initPoint, endPoint):
      map[p.x - xMin][p.y - yMin] = Rock

    initPoint = endPoint

echo "Answer: ", simulate(map, Coordinate(x: sandSource.x - xMin, y: sandSource.y - yMin))
