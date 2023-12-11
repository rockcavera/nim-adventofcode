import std/[algorithm, cmdline, strutils, tables]

let inputFile = if paramCount() == 0: "input.txt"
                else: paramStr(1)

type
  CamelCards = enum
    Card2,
    Card3,
    Card4,
    Card5,
    Card6,
    Card7,
    Card8,
    Card9,
    CardT,
    CardJ,
    CardQ,
    CardK,
    CardA

  HandKinds = enum
    HighCard,     # 23456
    OnePair,      # A23A4
    TwoPair,      # 23432
    ThreeOfAKind, # TTT98
    FullHouse,    # 23332
    FourOfAKind,  # AA8AA
    FiveOfAKind   # AAAAA

  Hand = object
    kind: HandKinds
    cards: array[5, CamelCards]
    bid: int

proc charToCamelCard(c: char): CamelCards =
  case c
  of '2':
    result = Card2
  of '3':
    result = Card3
  of '4':
    result = Card4
  of '5':
    result = Card5
  of '6':
    result = Card6
  of '7':
    result = Card7
  of '8':
    result = Card8
  of '9':
    result = Card9
  of 'T':
    result = CardT
  of 'J':
    result = CardJ
  of 'Q':
    result = CardQ
  of 'K':
    result = CardK
  of 'A':
    result = CardA
  else:
    raise newException(CatchableError, "invalid camel card")

proc returnsHandType(hand: CountTable[CamelCards]): HandKinds =
  case len(hand)
  of 1:
    result = FiveOfAKind
  of 2:
    let (_, count) = largest(hand)

    case count
    of 4:
      result = FourOfAKind
    of 3:
      result = FullHouse
    else:
      raise newException(CatchableError, "Cannot have 2 card labels and another type of hand")
  of 3:
    let (_, count) = largest(hand)

    case count
    of 3:
      result = ThreeOfAKind
    of 2:
      result = TwoPair
    else:
      raise newException(CatchableError, "Cannot have 3 card labels and another type of hand")
  of 4:
    result = OnePair
  of 5:
    result = HighCard
  else:
    raise newException(CatchableError, "number of invalid card labels")

proc cmpHands(x, y: Hand): int =
  result = cmp(x.kind, y.kind)

  if result == 0:
    for i in 0 .. 4:
      result = cmp(x.cards[i], y.cards[i])

      if result != 0:
        break

proc part01(): int =
  # Find the rank of every hand in your set.
  # What are the total winnings?
  var hands: seq[Hand]

  for line in lines(inputFile):
    var hand: Hand

    let data = split(line, ' ')

    hand.bid = parseInt(data[1])

    var i = 0

    for c in data[0]:
      hand.cards[i] = charToCamelCard(c)

      inc(i)

    let countHand = toCountTable(hand.cards)

    hand.kind = returnsHandType(countHand)

    add(hands, hand)

  sort(hands, cmpHands)

  for i in 0 .. high(hands):
    result += hands[i].bid * (i + 1)

echo "Answer Part 01: ", part01()

proc returnsHandType2(hand: CountTable[CamelCards]): HandKinds =
  if contains(hand, CardJ):
    let amountCardJ = hand[CardJ]

    if amountCardJ == 5:
      result = FiveOfAKind
    else:
      var
        better: tuple[card: CamelCards, amount: int]
        newHand = initCountTable[CamelCards](5)

      for key, value in pairs(hand):
        if key != CardJ:
          if value > better.amount:
            better.amount = value
            better.card = key

          inc(newHand, key, value)

      inc(newHand, better.card, amountCardJ)

      result = returnsHandType(newHand)
  else:
    result = returnsHandType(hand)

proc cmpHands2(x, y: Hand): int =
  result = cmp(x.kind, y.kind)

  if result == 0:
    for i in 0 .. 4:
      var
        cardx = ord(x.cards[i])
        cardy = ord(y.cards[i])

      if cardx == ord(CardJ):
        cardx = -1

      if cardy == ord(CardJ):
        cardy = -1

      result = cmp(cardx, cardy)

      if result != 0:
        break

proc part02(): int =
  # Using the new joker rule, find the rank of every hand in your set.
  # What are the new total winnings?
  var hands: seq[Hand]

  for line in lines(inputFile):
    var hand: Hand

    let data = split(line, ' ')

    hand.bid = parseInt(data[1])

    var i = 0

    for c in data[0]:
      hand.cards[i] = charToCamelCard(c)

      inc(i)

    let countHand = toCountTable(hand.cards)

    hand.kind = returnsHandType2(countHand)

    add(hands, hand)

  sort(hands, cmpHands2)

  for i in 0 .. high(hands):
    result += hands[i].bid * (i + 1)

echo "Answer Part 02: ", part02()
