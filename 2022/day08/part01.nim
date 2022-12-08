const
  width = 99
  hight = 99

var
  e = 0
  map: array[hight, array[width, int]]

proc isVisible(x, y: int): bool =
  let a = map[x][y]

  block top:
    for i in countdown(x - 1, 0):
      if a <= map[i][y]:
        break top
    return true

  block bottom:
    for i in (x + 1) ..< hight:
      if a <= map[i][y]:
        break bottom
    return true

  block left:
    for i in countdown(y - 1, 0):
      if a <= map[x][i]:
        break left
    return true

  block right:
    for i in (y + 1) ..< width:
      if a <= map[x][i]:
        break right
    return true

for l in lines("input.txt"):
  for i,v in l:
    map[e][i] = ord(v) - ord('0')

  inc(e)

var visibleTrees = width * 2 + ((hight - 2) * 2)

for x in 1 ..< high(map):
  for y in 1 ..< high(map[x]):
    if isVisible(x, y):
      inc(visibleTrees)

echo "Answer: ", visibleTrees
