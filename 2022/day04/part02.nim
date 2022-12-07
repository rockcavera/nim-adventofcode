import std/[strscans, strformat]

var countOverlap = 0

for l in lines("input.txt"):
  var i1, i2, e1, e2: int

  if scanf(l, "$i-$i,$i-$i", i1, e1, i2, e2):
    let
      p1 = { i1..e1 }
      p2 = { i2..e2 }

    if (len(p1) + len(p2)) > len(p1 + p2):
      inc(countOverlap)

echo fmt"Ranges overlap in {countOverlap} pairs"
