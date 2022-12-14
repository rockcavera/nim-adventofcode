import std/[json]

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

var
  i = 1
  p = false
  packets: array[2, JsonNode]
  sumIndex = 0

for l in lines("input.txt"):
  if l == "":
    inc(i)
    continue

  packets[int(p)] = parseJson(l)

  if p:
    if cmpPackets(packets[0], packets[1]) == RightOrder:
      sumIndex += i

  p = not(p)

echo "Answer: ", sumIndex
