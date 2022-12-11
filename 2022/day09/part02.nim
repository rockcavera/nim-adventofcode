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
  nodes: array[10, Coordinate]

inc(trackTailPositions, nodes[9])

for l in lines("input.txt"):
  var
    command: char
    amount: int

  if scanf(l, "$c $i", command, amount):
    for i in 1 .. amount:
      var
        a = 0 # head
        b = 1 # node 1

      case command
      of 'R':
        inc(nodes[a].x)
      of 'L':
        dec(nodes[a].x)
      of 'U':
        inc(nodes[a].y)
      of 'D':
        dec(nodes[a].y)
      else:
        echo fmt"Bad command '{command}'"

      while a < 9:
        let (c, total) = distance(nodes[a], nodes[b])

        if total > 1:
          if c.x != 0:
            if c.x > 0:
              inc(nodes[b].x)
            else:
              dec(nodes[b].x)

          if c.y != 0:
            if c.y > 0:
              inc(nodes[b].y)
            else:
              dec(nodes[b].y)

          if b == 9:
            inc(trackTailPositions, nodes[9])
        else:
          break

        inc(a)
        inc(b)

echo fmt"Answer: {len(trackTailPositions)}"
