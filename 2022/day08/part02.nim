const
  width = 99
  hight = 99

var
  e = 0
  map: array[hight, array[width, int]]
  highestScenicScore = -1

proc scenicScore(x, y: int): int =
  result = 1

  let a = map[x][y]

  var visible = 0

  block top:
    for i in countdown(x - 1, 0):
      inc(visible)
      if a <= map[i][y]:
        break top

  result *= visible
  visible = 0

  block bottom:
    for i in (x + 1) ..< hight:
      inc(visible)
      if a <= map[i][y]:
        break bottom

  result *= visible
  visible = 0

  block left:
    for i in countdown(y - 1, 0):
      inc(visible)
      if a <= map[x][i]:
        break left

  result *= visible
  visible = 0

  block right:
    for i in (y + 1) ..< width:
      inc(visible)
      if a <= map[x][i]:
        break right

  result *= visible

for l in lines("input.txt"):
  for i,v in l:
    map[e][i] = ord(v) - ord('0')

  inc(e)

var visibleTrees = width * 2 + ((hight - 2) * 2)

for x in 1 ..< high(map):
  for y in 1 ..< high(map[x]):
    let score =  scenicScore(x, y)

    if score > highestScenicScore:
      highestScenicScore = score

echo "Answer: ", highestScenicScore
