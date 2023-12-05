import std/[cmdline, strutils, tables]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

proc part01(): int =
  # What is the sum of the IDs of those games?
  let bagCubes = {"red": 12, "green": 13, "blue": 14}.toTable()

  for line in lines(inputFile):
    let game = split(line, ':')

    var possible = true

    block checkGame:
      for round in split(game[1], ';'):
        for cube in split(round, ','):
          let
            amountColor = splitWhitespace(cube)
            amount = parseInt(amountColor[0])
            color = amountColor[1]

          if amount > bagCubes[color]:
            possible = false

            break checkGame

    if possible:
      result += parseInt(splitWhitespace(game[0])[1])

echo "Answer Part 01: ", part01()

proc part02(): int =
  # What is the sum of the power of these sets?
  for line in lines(inputFile):
    var bagCubes = {"red": 0, "green": 0, "blue": 0}.toTable()

    let game = split(line, ':')

    for round in split(game[1], ';'):
      for cube in split(round, ','):
        let
          amountColor = splitWhitespace(cube)
          amount = parseInt(amountColor[0])
          color = amountColor[1]

        if amount > bagCubes[color]:
          bagCubes[color] = amount

    let power = bagCubes["red"] * bagCubes["green"] * bagCubes["blue"]

    result += power

echo "Answer Part 02: ", part02()
