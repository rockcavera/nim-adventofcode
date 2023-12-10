import std/[cmdline, strutils]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

proc travelledDistance(speed, time: int): int =
  speed * time

proc part01(): int =
  # Determine the number of ways you could beat the record in each race.
  # What do you get if you multiply these numbers together?
  var times, distances: seq[int]

  for line in lines(inputFile):
    if startsWith(line, "Time:"):
      for time in splitWhitespace(split(line, ':')[1]):
        add(times, parseInt(time))
    elif startsWith(line, "Distance:"):
      for distance in splitWhitespace(split(line, ':')[1]):
        add(distances, parseInt(distance))
    else:
      discard

  for i in 0 .. high(times):
    let
      time = times[i]
      recordDistance = distances[i]

    var waysToBeatTheRecord = 0

    for speed in 0 .. time:
      let distance = travelledDistance(speed, time - speed)

      if distance > recordDistance:
        inc(waysToBeatTheRecord)

    if i == 0:
      result = waysToBeatTheRecord
    else:
      result = result * waysToBeatTheRecord

echo "Answer Part 01: ", part01()

proc part02(): int =
  # How many ways can you beat the record in this one much longer race?
  var raceTime, recordDistance: int

  for line in lines(inputFile):
    if startsWith(line, "Time:"):
      raceTime = parseInt(replace(split(line, ':')[1], " ", ""))
    elif startsWith(line, "Distance:"):
      recordDistance = parseInt(replace(split(line, ':')[1], " ", ""))
    else:
      discard

  for speed in 0 .. raceTime:
    let distance = travelledDistance(speed, raceTime - speed)

    if distance > recordDistance:
      inc(result)

echo "Answer Part 02: ", part02()
