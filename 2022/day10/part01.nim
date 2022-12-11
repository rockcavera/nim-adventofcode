import std/[strscans, streams, strformat]

var
  cycles = 0
  regX = 1
  sumSignalStrengths = 0
  y = 20
  processingInstruction = false
  addx: int
  fs = newFileStream("input.txt", fmRead)

if isNil(fs):
  quit(1)

while true:
  inc(cycles)
  inc(y)

  if y == 40:
    sumSignalStrengths += cycles * regX

    y = 0

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

echo fmt"Answer: {sumSignalStrengths}"
