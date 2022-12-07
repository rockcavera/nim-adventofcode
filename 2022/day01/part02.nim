import std/[algorithm, math, strutils, strformat]

var
  firstThreeElves: array[4, int]
  carryingCalories: seq[int]

for l in lines("input.txt"):
  if l == "":
    firstThreeElves[3] = sum(carryingCalories)

    sort(firstThreeElves, Descending)

    setLen(carryingCalories, 0)

    continue

  add(carryingCalories, parseInt(l))

if len(carryingCalories) > 0:
  firstThreeElves[3] = sum(carryingCalories)

  sort(firstThreeElves, Descending)

let sumCalories = sum(firstThreeElves[0..2])

echo fmt"The elf carries a total of {sumCalories} calories"
