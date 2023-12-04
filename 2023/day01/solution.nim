import std/[cmdline, strutils, tables]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

proc part01(): int =
  for line in lines(inputFile):
    for c in line:
      if c in {'0' .. '9'}:
        result += 10 * (ord(c) - ord('0'))
        break

    for i in countdown(high(line), 0):
      if line[i] in {'0' .. '9'}:
        result += ord(line[i]) - ord('0')
        break

echo "Answer Part 01: ", part01()

proc part02(): int =
  let numbers = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9}.toTable()

  for line in lines(inputFile):
    block firstDigit:
      for i in 0 .. high(line):
        let c = line[i]
        if c in {'0' .. '9'}:
          result += 10 * (ord(c) - ord('0'))
          break firstDigit
        elif c in {'a' .. 'z'}:
          for key, value in pairs(numbers):
            if find(line, key, 0, i) > -1:
              result += 10 * value
              break firstDigit

    block secondDigit:
      for i in countdown(high(line), 0):
        let c = line[i]

        if c in {'0' .. '9'}:
          result += ord(c) - ord('0')
          break secondDigit
        elif c in {'a' .. 'z'}:
          for key, value in pairs(numbers):
            if find(line, key, i, high(line)) > -1:
              result += value
              break secondDigit

echo "Answer Part 02: ", part02()
