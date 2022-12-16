import std/[sets, strscans]

type
  Coordinate = object
    x, y: int

  Sensor = object
    pos: Coordinate
    beacon: Coordinate

proc rhombus(a: Coordinate, d: int, c: int, count: var HashSet[Coordinate]) =
  var
    y1 = a.y - d
    x1, x2 = a.x

  if y1 == c:
    incl(count, Coordinate(x: a.x, y: y1))

  for y in (y1 + 1) .. a.y:
    dec(x1)
    inc(x2)

    if y == c:
      for x in x1 .. x2:
        incl(count, Coordinate(x: x, y: y))

  for y in (a.y + 1) .. (a.y + d):
    inc(x1)
    dec(x2)

    if y == c:
      for x in x1 .. x2:
        incl(count, Coordinate(x: x, y: y))

func distance(a, b: Coordinate): int =
  abs(a.x - b.x) + abs(a.y - b.y)

const yToCheck = 2_000_000

var sensors = newSeqOfCap[Sensor](31)

for l in lines("input.txt"):
  var s: Sensor

  if scanf(l, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", s.pos.x, s.pos.y, s.beacon.x, s.beacon.y):
    add(sensors, s)

var count = initHashSet[Coordinate]()

for i in sensors:
  let
    d = distance(i.pos, i.beacon)
    vY1 = i.pos.y - d
    vY2 = i.pos.y + d

  if vy1 <= yToCheck and vy2 >= yToCheck:
    rhombus(i.pos, d, yToCheck, count)

for i in sensors:
  excl(count, i.beacon)

echo "Answer: ", len(count)
