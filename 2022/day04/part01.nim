import std/[strscans, strformat]

var countFullyContain = 0

for l in lines("input.txt"):
  var i1, i2, e1, e2: int

  if scanf(l, "$i-$i,$i-$i", i1, e1, i2, e2):
    let
      p1 = { i1..e1 }
      p2 = { i2..e2 }

    if p1 == p2 or p1 < p2 or p2 < p1:
      inc(countFullyContain)

echo fmt"One pair fully contains the other in {countFullyContain} assignments"
