import std/[strscans, strformat, tables]

type
  Coordinate = object
    x, y: int

proc distance(a, b: Coordinate): tuple[c: Coordinate, total: int] =
  result.c.x = a.x - b.x
  result.c.y = a.y - b.y

  if (result.c.x or result.c.y) == 0:
    result.total = 0
  else:
    if result.c.x == 0:
      result.total = result.c.y
    elif result.c.y == 0:
      result.total = result.c.x
    else:
      result.total = result.c.y * result.c.x

  result.total = abs(result.total)

var
  trackTailPositions = initCountTable[Coordinate]()
  headPos = Coordinate(x: 0, y: 0)
  tailPos = Coordinate(x: 0, y: 0)

inc(trackTailPositions, tailPos)

for l in lines("input.txt"):
  var
    command: char
    amount: int

  if scanf(l, "$c $i", command, amount):
    for i in 1 .. amount:
      case command
      of 'R':
        inc(headPos.x)
      of 'L':
        dec(headPos.x)
      of 'U':
        inc(headPos.y)
      of 'D':
        dec(headPos.y)
      else:
        echo fmt"Bad command '{command}'"

      let (c, total) = distance(headPos, tailPos)

      if total > 1:
        if c.x != 0:
          if c.x > 0:
            inc(tailPos.x)
          else:
            dec(tailPos.x)

        if c.y != 0:
          if c.y > 0:
            inc(tailPos.y)
          else:
            dec(tailPos.y)

        inc(trackTailPositions, tailPos)

echo fmt"Answer: {len(trackTailPositions)}"
