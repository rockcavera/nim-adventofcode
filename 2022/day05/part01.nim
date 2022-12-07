import std/[algorithm, streams, strscans]

var fs = newFileStream("input.txt", fmRead)

if isNil(fs):
  quit(1)

var
  l: string
  map: seq[seq[char]]
  readFirstLine = false

# MAP
while readLine(fs, l):
  if l == "": break

  if not readFirstLine:
    map = newSeq[seq[char]]((len(l) + 1) div 4)
    readFirstLine = true

  var
    x = 0
    i = 1

  let limit = high(l)

  while i < limit:
    let c = l[i]

    if c != ' ':
      add(map[x], c)

    inc(x)
    inc(i, 4)

for i in 0 .. high(map):
  reverse(map[i])

# Rearrangement procedure
while readLine(fs, l):
  var amount, f, to: int

  if scanf(l, "move $i from $i to $i", amount, f, to):
    dec(f)
    dec(to)
    for i in 1 .. amount:
      let a = pop(map[f])
      add(map[to], a)

close(fs)

# Answer
for s in map:
  write(stdout, s[^1])
