import std/[algorithm, deques, strutils, strscans, streams]

type
  Operation = object
    operator: proc(x, y: int): int
    element: int # 0 = old
    by: int # 0 = old

  Test = object
    divisor: int # Divisor
    ifTrue: int # index of the monkey that will receive
    ifFalse: int # index of the monkey that will receive

  Monkey = object
    items: Deque[int]
    operation: Operation
    test: Test
    inspectedItems: int

func addition(x, y: int): int =
  x + y

func multiplication(x, y: int): int =
  x * y

var
  monkeys = newSeq[Monkey](8)
  iMonkey = 0
  lenMonkeys = 0
  fs = newFileStream("input.txt", fmRead)
  l: string

# Parse the monkeys
while readLine(fs, l):
  if l == "":
    continue

  if scanf(l, "Monkey $i:", iMonkey):
    inc(lenMonkeys)

    monkeys[iMonkey].items = initDeque[int](36)

    var
      strListItems: string
      strOperation: string
      by: int
      i: int

    if readLine(fs, l) and scanf(l, "  Starting items: $+$.", strListItems):
      for n in split(strListItems, ", "):
        addLast(monkeys[iMonkey].items, parseInt(n))

    if readLine(fs, l) and scanf(l, "  Operation: new = $+$.", strOperation):
      let parts = split(strOperation, ' ')

      monkeys[iMonkey].operation.element = if parts[0] == "old": 0
                                           else: parseInt(parts[0])
      monkeys[iMonkey].operation.by = if parts[2] == "old": 0
                                      else: parseInt(parts[2])

      case parts[1]
      of "*":
        monkeys[iMonkey].operation.operator = multiplication
      of "+":
        monkeys[iMonkey].operation.operator = addition
      else:
        discard

    if readLine(fs, l) and scanf(l, "  Test: divisible by $i", by):
      monkeys[iMonkey].test.divisor = by

      if readLine(fs, l) and scanf(l, "    If true: throw to monkey $i", i):
        monkeys[iMonkey].test.ifTrue = i

      if readLine(fs, l) and scanf(l, "    If false: throw to monkey $i", i):
        monkeys[iMonkey].test.ifFalse = i

close(fs)

setLen(monkeys, lenMonkeys)

var rounds = 1

while rounds <= 20:
  iMonkey = 0

  while iMonkey < lenMonkeys:
    while len(monkeys[iMonkey].items) > 0:
      inc(monkeys[iMonkey].inspectedItems)

      let old = popFirst(monkeys[iMonkey].items)

      var newLevel: int

      if (monkeys[iMonkey].operation.element == 0) and (monkeys[iMonkey].operation.by == 0):
        newLevel = monkeys[iMonkey].operation.operator(old, old)
      elif monkeys[iMonkey].operation.element == 0:
        newLevel = monkeys[iMonkey].operation.operator(old, monkeys[iMonkey].operation.by)
      elif monkeys[iMonkey].operation.by == 0:
        newLevel = monkeys[iMonkey].operation.operator(old, monkeys[iMonkey].operation.element)
      else:
        newLevel = monkeys[iMonkey].operation.operator(monkeys[iMonkey].operation.by, monkeys[iMonkey].operation.element)

      newLevel = newLevel div 3

      if (newLevel mod monkeys[iMonkey].test.divisor) == 0:
        addLast(monkeys[monkeys[iMonkey].test.ifTrue].items, newLevel)
      else:
        addLast(monkeys[monkeys[iMonkey].test.ifFalse].items, newLevel)

    inc(iMonkey)

  inc(rounds)

var inspectedItems = newSeqOfCap[int](len(monkeys))

for m in monkeys:
  add(inspectedItems, m.inspectedItems)

sort(inspectedItems, Descending)

echo "Answer: ", inspectedItems[0] * inspectedItems[1]
