import std/[strscans, streams, strformat]

var
  cycles = 0
  regX = 1
  processingInstruction = false
  addx: int
  fs = newFileStream("input.txt", fmRead)
  x, y = 0 #

if isNil(fs):
  quit(1)

while true:
  inc(cycles)

  var c = '.' # dark

  if x in (regX - 1)..(regX + 1):
    c = '#' # lit

  write(stdout, c)

  inc(x)

  if x > 39:
    write(stdout, '\n')

    x = 0

    inc(y)

    if y > 5:
      break

  if processingInstruction:
    inc(regX, addx)

    processingInstruction = false
  else:
    var l: string

    if readLine(fs, l):
      if "noop" == l:
        discard
      else:
        if scanf(l, "addx $i", addx):
          processingInstruction = true
        else:
          echo fmt"Bad line '{l}'"
    else:
      break

close(fs)
