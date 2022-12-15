import std/[strutils, strscans]

type
  Coordinate = object
    x, y: int

  Objects = enum
    Air, Rock, Sand, Source

  Movements = enum
    Left, Right, Up, Down

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

proc isOnTheMap(p: Coordinate, w, h: int): bool =
  p.x >= 0 and p.x < w and p.y >= 0 and p.y < h

proc simulate(map: var seq[seq[Objects]], source: Coordinate): int =
  let
    width = len(map)
    hight = len(map[0])

  block flowingIntoAbyss:
    while true:
      var sand, np = source

      block sandStopped:
        while true:
          inc(np.y) # Down

          if isOnTheMap(np, width, hight):
            if map[np.x][np.y] == Air:
              sand = np
              continue

            dec(np.x) # Left

            if isOnTheMap(np, width, hight):
              if map[np.x][np.y] == Air:
                sand = np
                continue

              inc(np.x, 2) # Right

              if isOnTheMap(np, width, hight):
                if map[np.x][np.y] == Air:
                  sand = np
                  continue

                break sandStopped
              else:
                break flowingIntoAbyss
            else:
              break flowingIntoAbyss
          else:
            break flowingIntoAbyss

      map[sand.x][sand.y] = Sand

      inc(result)

const sandSource = Coordinate(x: 500, y: 0)

var
  rocks = newSeqOfCap[seq[Coordinate]](137)
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
