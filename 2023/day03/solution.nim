import std/[cmdline, parseutils]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

proc isPartNumber(engineSchematic: seq[string], x, y, size: int): bool =
  for y1 in (y - 1) .. (y + 1):
    if y1 >= 0 and y1 < len(engineSchematic):
      for x1 in (x - 1) .. (x + size):
        if x1 >= 0 and x1 < len(engineSchematic[y1]):
          if engineSchematic[y1][x1] notin {'.', '0'..'9'}:
            return true

proc part01(): int =
  # What is the sum of all of the part numbers in the engine schematic?
  var engineSchematic: seq[string]

  for line in lines(inputFile):
    add(engineSchematic, line)

  var y = 0

  while y < len(engineSchematic):
    var x = 0

    while x < len(engineSchematic[y]):
      let c = engineSchematic[y][x]

      var incSize = 1

      if c in {'0'..'9'}:
        var number: int

        let processed = parseInt(engineSchematic[y], number, x)

        if isPartNumber(engineSchematic, x, y, processed):
          result += number
          incSize = processed

      inc(x, incSize)

    inc(y)

echo "Answer Part 01: ", part01()

proc parseNumber(line: var string, x: int): int =
  var x = x

  while x >= 0 and line[x] in {'0'..'9'}:
    dec(x)

  inc(x)

  while x < len(line) and line[x] in {'0'..'9'}:
    result = result * 10 + (ord(line[x]) - ord('0'))
    line[x] = '.'

    inc(x)

proc isGear(engineSchematic: seq[string], x, y: int, gearRatio: var int): bool =
  var
    engineSchematic = engineSchematic
    partNumbers = newSeqOfCap[int](2)

  for y1 in (y - 1) .. (y + 1):
    if y1 >= 0 and y1 < len(engineSchematic):
      for x1 in (x - 1) .. (x + 1):
        if x1 >= 0 and x1 < len(engineSchematic[y1]):
          if engineSchematic[y1][x1] in {'0'..'9'}:
            add(partNumbers, parseNumber(engineSchematic[y1], x1))

  if len(partNumbers) == 2:
    result = true
    gearRatio = partNumbers[0] * partNumbers[1]

proc part02(): int =
  # What is the sum of all of the gear ratios in your engine schematic?
  var engineSchematic: seq[string]

  for line in lines(inputFile):
    add(engineSchematic, line)

  var y = 0

  while y < len(engineSchematic):
    var x = 0

    while x < len(engineSchematic[y]):
      let c = engineSchematic[y][x]

      if c == '*':
        var gearRatio: int

        if isGear(engineSchematic, x, y, gearRatio):
          result += gearRatio

      inc(x)

    inc(y)

echo "Answer Part 02: ", part02()
