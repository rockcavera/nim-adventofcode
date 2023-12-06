import std/[cmdline, sets, strutils]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

proc part01(): int =
  # How many points are they worth in total?
  for line in lines(inputFile):
    var
      winNumbers = initHashSet[int]()
      points = 0

    let numbers = split(split(line, ':')[1], '|')

    for number in splitWhitespace(numbers[0]):
      incl(winNumbers, parseInt(number))

    for number in splitWhitespace(numbers[1]):
      if contains(winNumbers, parseInt(number)):
        inc(points)

    if points > 0:
      result += 1 shl (points - 1)

echo "Answer Part 01: ", part01()

proc countLines(fileName: string): int =
  for line in lines(fileName):
    inc(result)

proc part02(): int =
  # How many total scratchcards do you end up with?
  var
    cards = newSeq[int](countLines(inputFile))
    i = 0

  for line in lines(inputFile):
    inc(cards[i])

    var
      winNumbers = initHashSet[int]()
      points = 0

    let numbers = split(split(line, ':')[1], '|')

    for number in splitWhitespace(numbers[0]):
      incl(winNumbers, parseInt(number))

    for number in splitWhitespace(numbers[1]):
      if contains(winNumbers, parseInt(number)):
        inc(points)

    for j in (i + 1) .. (i + points):
      inc(cards[j], cards[i])

    inc(i)

  for n in cards:
    result += n

echo "Answer Part 02: ", part02()
