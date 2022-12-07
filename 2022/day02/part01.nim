import std/strscans

type
  RockPaperScissors = enum
    Rock, Paper, Scissor

template pointsGame(c, r, p, s: int) =
  # choice, rock, paper, scissor
  result = c
  case b
    of Rock:
      result += r
    of Paper:
      result += p
    of Scissor:
      result += s

proc compareAndReturnPoints(a, b: RockPaperScissors): int =
  case a
  of Rock:
    pointsGame(1, 3, 0, 6)
  of Paper:
    pointsGame(2, 6, 3, 0)
  of Scissor:
    pointsGame(3, 0, 6, 3)

var myPoints = 0

for l in lines("input.txt"):
  if l == "":
    continue

  var
    e, m: char
    elfChoice: RockPaperScissors
    myChoice: RockPaperScissors

  if scanf(l, "$c $c", e, m):
    elfChoice = RockPaperScissors(ord(e) - 65)
    myChoice = RockPaperScissors(ord(m) - 88)

    myPoints += compareAndReturnPoints(myChoice, elfChoice)

echo "my Points: ", myPoints
