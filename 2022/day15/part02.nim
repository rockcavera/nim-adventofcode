import std/[strscans]

const
  limitMinX = 0
  limitMaxX = 4_000_000
  limitMinY = 0
  limitMaxY = 4_000_000

type
  Coordinate = object
    x, y: int

  HorizontalLine = object
    x1, x2: int

  Sensor = object
    pos: Coordinate
    beacon: Coordinate

func pointInsideLine(p, l1, l2: int): bool =
  p >= l1 and p <= l2

func distance(a, b: Coordinate): int =
  abs(a.x - b.x) + abs(a.y - b.y)

proc checkLines(hl: var seq[HorizontalLine], x1, x2: int) =
  var nLines = newSeqOfCap[HorizontalLine](len(hl) * 2)

  for l in hl:
    if x1 < l.x1:
      if x2 < l.x1:
        add(nLines, l)
      else: # x2 >= l.x1
        if x2 < l.x2:
          var nl = l

          nl.x1 = x2 + 1

          add(nLines, nl)
        # else x2 >= l.x2 - Corta inteira
    elif x1 == l.x1:
      if x2 < l.x2:
        var nl = l

        nl.x1 = x2 + 1

        add(nLines, nl)
      # else x2 >= l.x2 - Corta inteira
    else: # x1 > l.x1
      if x1 > l.x2:
        add(nLines, l)
      elif x1 == l.x2:
        var nl = l

        nl.x2 = x1 - 1

        add(nLines, nl)
      else: # x1 < l.x2
        if x2 >= l.x2:
          var nl = l

          nl.x2 = x1 - 1

          add(nLines, nl)
        else: # x2 < l.x2
          var
            nl1 = l
            nl2 = l

          nl1.x2 = x1 - 1
          nl2.x1 = x2 + 1

          add(nLines, @[nl1, nl2])

  hl = nLines

proc rhombus(a: Coordinate, d: int, hl: var array[limitMaxY - limitMinY + 1, seq[HorizontalLine]]) =
  var
    y1 = a.y - d
    x1, x2 = a.x

  for y in (y1 + 1) .. a.y:
    dec(x1)
    inc(x2)

    if pointInsideLine(y, limitMinY, limitMaxY) and len(hl[y]) != 0 and (pointInsideLine(x1, limitMinX, limitMaxX) or pointInsideLine(x2, limitMinX, limitMaxX)):
      checkLines(hl[y], x1, x2)

  for y in (a.y + 1) .. (a.y + d):
    inc(x1)
    dec(x2)

    if pointInsideLine(y, limitMinY, limitMaxY) and (pointInsideLine(x1, limitMinX, limitMaxX) or pointInsideLine(x2, limitMinX, limitMaxX)):
      checkLines(hl[y], x1, x2)

var sensors = newSeqOfCap[Sensor](31)

for l in lines("input.txt"):
  var s: Sensor

  if scanf(l, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", s.pos.x, s.pos.y, s.beacon.x, s.beacon.y):
    add(sensors, s)

var hLines: array[limitMaxY - limitMinY + 1, seq[HorizontalLine]]

for i in 0 .. high(hLines):
  hLines[i] = newSeq[HorizontalLine](1)

  hLines[i][0].x1 = limitMinX
  hLines[i][0].x2 = limitMaxX

for s in sensors:
  rhombus(s.pos, distance(s.pos, s.beacon), hLines)

for y, l in hLines:
  if len(l) > 0:
    if (l[0].x1 - l[0].x2) == 0:
      echo "Answer: ", l[0].x1 * 4_000_000 + y
