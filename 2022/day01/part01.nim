import std/[math, strutils, strformat]

var
  elfMostCalories = -1
  carryingCalories: seq[int]

for l in lines("input.txt"):
  if l == "":
    let sumCalories = sum(carryingCalories)

    if sumCalories > elfMostCalories:
      elfMostCalories = sumCalories

    setLen(carryingCalories, 0)

    continue

  add(carryingCalories, parseInt(l))

if len(carryingCalories) > 0:
  let sumCalories = sum(carryingCalories)

  if sumCalories > elfMostCalories:
    elfMostCalories = sumCalories

echo fmt"The elf carries a total of {elfMostCalories} calories"
