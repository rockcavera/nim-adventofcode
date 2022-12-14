import std/[algorithm, json]

type
  MyObject = object
    first: int
    elements: int
    packet: JsonNode

proc findFirst(a: JsonNode): int =
  for n in a:
    case n.kind
    of JInt:
      result = getInt(n)
      break
    of JArray:
      result = findFirst(n)
      break
    else:
      discard

proc countElements(a: JsonNode): int =
  for n in a:
    case n.kind
    of JInt:
      inc(result)
    of JArray:
      result += countElements(n)
    else:
      discard

proc cmp(x, y: MyObject): int =
  if x.first < y.first:
    result = -1
  elif x.first > y.first:
    result = 1
  else:
    if x.elements < y.elements:
      result = -1
    elif x.elements > y.elements:
      result = 1

let dividerPackets = [parseJson("[[2]]"), parseJson("[[6]]")]

var
  packets = newSeqOfCap[MyObject](302)
  indexDivider1, indexDivider2 = -1

for l in lines("input.txt"):
  if l == "":
    continue

  var myObject: MyObject

  myObject.packet = parseJson(l)
  myObject.first = findFirst(myObject.packet)
  myObject.elements = countElements(myObject.packet)

  add(packets, myObject)

for p in dividerPackets:
  var myObject: MyObject

  myObject.packet = p
  myObject.first = findFirst(myObject.packet)
  myObject.elements = countElements(myObject.packet)

  add(packets, myObject)

sort(packets, cmp)

for i,p in packets:
  if p.packet == dividerPackets[0]:
    indexDivider1 = i + 1
  elif p.packet == dividerPackets[1]:
    indexDivider2 = i + 1

echo "Answer: ", indexDivider1 * indexDivider2
