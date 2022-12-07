import std/[streams, tables]

var fs = newFileStream("input.txt", fmRead)

if isNil(fs):
  quit(1)

let signal = readLine(fs)

close(fs)

var
  x = 0
  answer = x + 3

while answer <= high(signal):
  let countChars = toCountTable(signal[x..answer])

  if len(countChars) == 4:
    break

  inc(x)

  answer = x + 3

echo answer + 1
