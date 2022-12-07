import std/[tables]

proc getPriorities(x: char): int =
  case x
  of { 'a'..'z' }:
    result = ord(x) - 96
  of { 'A'..'Z' }:
    result = ord(x) - 38
  else:
    discard

var
  sumPriorities = 0
  countLR = 0
  rucksacksItems = initCountTable[char](64)

for l in lines("input.txt"):
  inc(countLR)

  let allItems = toCountTable(l)

  for c in keys(allItems):
    inc(rucksacksItems, c)

  if countLR == 3:
    let (c, _) = largest(rucksacksItems)

    sumPriorities += getPriorities(c)

    clear(rucksacksItems)

    countLR = 0

echo "Sum of the priorities: ", sumPriorities
