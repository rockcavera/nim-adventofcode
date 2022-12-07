import std/strscans

type
  RockPaperScissors = enum
    Rock = 1, Paper = 2, Scissor = 3

  RoundResult = enum
    Lose, Draw, Win

template pointsGame(rr: int, r, p, s: RockPaperScissors) =
  # `rr` round result point, `r` my choice point for rock, `p` my choice point for paper, `s` my choice point for scissor
  result = rr
  case b
    of Rock:
      result += ord(r)
    of Paper:
      result += ord(p)
    of Scissor:
      result += ord(s)

proc chooseAndReturnPoints(x: RoundResult, b: RockPaperScissors): int =
  # Compara e retorna os pontos
  case x
  of Lose:
    pointsGame(0, Scissor, Rock, Paper) # Scissor lose to Rock, Rock lose to Paper, Paper lose to Scissor
  of Draw:
    pointsGame(3, Rock, Paper, Scissor) # Rock draw with Rock, Paper draw with Paper, Scissor draw with Scissor
  of Win:
    pointsGame(6, Paper, Scissor, Rock) # Paper beats Rock, Scissor beats Paper, Rock beats Scissor

var myPoints = 0

for l in lines("input.txt"):
  if l == "":
    continue

  var e, r: char

  if scanf(l, "$c $c", e, r):
    let
      elfChoice = RockPaperScissors(ord(e) - 64)
      roundResult = RoundResult(ord(r) - 88)

    myPoints += chooseAndReturnPoints(roundResult, elfChoice)

echo "my Points: ", myPoints
