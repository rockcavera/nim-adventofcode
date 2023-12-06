import std/[cmdline, strscans, strutils, tables]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

type
  Kinds = enum
    Seed,
    Soil,
    Fertilizer,
    Water,
    Light,
    Temperature,
    Humidity,
    Location

  Range = object
    destRangeStart: int
    sourceRangeStart: int
    rangeLen: int

  Map = object
    kindSource: Kinds
    kindDest: Kinds
    ranges: seq[Range]

proc parseSeeds(str: string): seq[int] =
  for seed in splitWhitespace(str):
    add(result, parseInt(seed))

proc strToKinds(str: string): Kinds =
  case str
  of "seed":
    result = Seed
  of "soil":
    result = Soil
  of "fertilizer":
    result = Fertilizer
  of "water":
    result = Water
  of "light":
    result = Light
  of "temperature":
    result = Temperature
  of "humidity":
    result = Humidity
  of "location":
    result = Location
  else:
    raise newException(CatchableError, "Unknown kind")

proc parseMapLabel(line: string): tuple[source, dest: Kinds] =
  var
    source: string
    dest: string

  if scanf(line, "$w-to-$w map:", source, dest):
    result.source = strToKinds(source)
    result.dest = strToKinds(dest)
  else:
    raise newException(CatchableError, "Impossible to parse map label")

proc parseAlmanac(): tuple[seeds: seq[int], maps: Table[Kinds, Map]] =
  var
    lineNumber = 0
    newMap = false
    currentMap: Map

  for line in lines(inputFile):
    inc(lineNumber)

    if lineNumber == 1:
      result.seeds = parseSeeds(split(line, ':')[1])
    elif line == "":
      newMap = true

      if len(currentMap.ranges) > 0:
        result.maps[currentMap.kindSource] = currentMap

        reset(currentMap)

      continue
    elif newMap:
      (currentMap.kindSource, currentMap.kindDest) = parseMapLabel(line)

      newMap = false
    else:
      var ranges: Range

      if scanf(line, "$i $i $i", ranges.destRangeStart, ranges.sourceRangeStart, ranges.rangeLen):
        add(currentMap.ranges, ranges)

  if len(currentMap.ranges) > 0:
        result.maps[currentMap.kindSource] = currentMap

proc contains(r: Range, value: int): bool =
  if value >= r.sourceRangeStart and value <= (r.sourceRangeStart + r.rangeLen - 1):
    result = true

proc part01(): int =
  # What is the lowest location number that corresponds to any of the initial seed numbers?
  result = high(int)

  let (seeds, maps) = parseAlmanac()

  for seed in seeds:
    var current: tuple[value: int, kind: Kinds] = (seed, Seed)

    while current.kind != Location:
      let map = maps[current.kind]

      var i = 0

      while i < len(map.ranges):
        if contains(map.ranges[i], current.value):
          current.value = map.ranges[i].destRangeStart + current.value - map.ranges[i].sourceRangeStart

          break

        inc(i)

      current.kind = map.kindDest

    if current.value < result:
      result = current.value

echo "Answer Part 01: ", part01()

proc part02(): int =
  # What is the lowest location number that corresponds to any of the initial seed numbers?
  result = high(int)

  let (seeds, maps) = parseAlmanac()

  for i in countup(0, high(seeds), 2):
    let lastSeed = seeds[i] + seeds[i + 1] - 1

    for seed in seeds[i] .. lastSeed:
      var current: tuple[value: int, kind: Kinds] = (seed, Seed)

      while current.kind != Location:
        let map = maps[current.kind]

        var i = 0

        while i < len(map.ranges):
          if contains(map.ranges[i], current.value):
            current.value = map.ranges[i].destRangeStart + current.value - map.ranges[i].sourceRangeStart

            break

          inc(i)

        current.kind = map.kindDest

      if current.value < result:
        result = current.value

echo "Answer Part 02: ", part02()
