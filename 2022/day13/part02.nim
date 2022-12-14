import std/[algorithm, json]

type
  Order = enum
    RightOrder = -1
    Next = 0
    NotRightOrder = 1

proc cmpPackets(a, b: JsonNode): int =
  var
    iA = 0
    iB = 0
    order = Next

  while order == Next:
    if iB < len(b) and iA < len(a):
      var
        nA = a.elems[iA]
        nB = b.elems[iB]

      if nA.kind == JInt and nB.kind == JInt:
        let
          intA = getInt(nA)
          intB = getInt(nB)

        if intA < intB:
          order = RightOrder
        elif intA > intB:
          order = NotRightOrder
      elif nA.kind == JArray and nB.kind == JArray:
        order = Order(cmpPackets(nA, nB))
      else:
        if nA.kind == JInt:
          nA = %([getInt(nA)])
        else:
          nB = %([getInt(nB)])

        order = Order(cmpPackets(nA, nB))

      inc(iB)
      inc(iA)
    elif iA == len(a) and iB == len(b):
      break
    elif iA == len(a):
      order = RightOrder
    else:
      order = NotRightOrder

  result = ord(order)

let dividerPackets = [parseJson("[[2]]"), parseJson("[[6]]")]

var
  packets = newSeqOfCap[JsonNode](302)
  indexDivider1, indexDivider2 = -1

for l in lines("input.txt"):
  if l == "":
    continue

  add(packets, parseJson(l))

add(packets, dividerPackets)

sort(packets, cmpPackets)

for i,p in packets:
  if p == dividerPackets[0]:
    indexDivider1 = i + 1
  elif p == dividerPackets[1]:
    indexDivider2 = i + 1

echo "Answer: ", indexDivider1 * indexDivider2
