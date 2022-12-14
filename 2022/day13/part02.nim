import std/[algorithm, json]

type
  Order = enum
    Next, RightOrder, NotRightOrder

proc cmpPackets(a, b: JsonNode): Order =
  var
    iA = 0
    iB = 0

  while result == Next:
    if iB < len(b) and iA < len(a):
      var
        nA = a.elems[iA]
        nB = b.elems[iB]

      if nA.kind == JInt and nB.kind == JInt:
        let
          intA = getInt(nA)
          intB = getInt(nB)

        if intA < intB:
          result = RightOrder
        elif intA > intB:
          result = NotRightOrder
      elif nA.kind == JArray and nB.kind == JArray:
        result = cmpPackets(nA, nB)
      else:
        if nA.kind == JInt:
          nA = %([getInt(nA)])
        else:
          nB = %([getInt(nB)])

        result = cmpPackets(nA, nB)

      inc(iB)
      inc(iA)
    elif iA == len(a) and iB == len(b):
      break
    elif iA == len(a):
      result = RightOrder
    else:
      result = NotRightOrder

proc cmp(x, y: JsonNode): int =
  case cmpPackets(x, y)
  of RightOrder:
    result = -1
  of NotRightOrder:
    result = 1
  of Next:
    result = 0

let dividerPackets = [parseJson("[[2]]"), parseJson("[[6]]")]

var
  packets = newSeqOfCap[JsonNode](302)
  indexDivider1, indexDivider2 = -1

for l in lines("input.txt"):
  if l == "":
    continue

  add(packets, parseJson(l))

add(packets, dividerPackets)

sort(packets, cmp)

for i,p in packets:
  if p == dividerPackets[0]:
    indexDivider1 = i + 1
  elif p == dividerPackets[1]:
    indexDivider2 = i + 1

echo "Answer: ", indexDivider1 * indexDivider2
