proc getPriorities(x: char): int =
  case x
  of { 'a'..'z' }:
    result = ord(x) - 96
  of { 'A'..'Z' }:
    result = ord(x) - 38
  else:
    discard

var sumPriorities = 0

for l in lines("input.txt"):
  let
    lDiv2 = len(l) div 2
    first = l[0..(lDiv2 - 1)]
    second = l[lDiv2..^1]

  for c in first:
    if find(second, c) > -1:
      sumPriorities += getPriorities(c)
      break

echo "Sum of the priorities: ", sumPriorities
