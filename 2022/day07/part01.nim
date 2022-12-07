import std/[parseutils, strscans, strformat]

type
  DirObj = object
    top: DirNode
    sub: seq[DirNode]
    name: string
    size: int
  DirNode = ref DirObj

  DirList = object
    head: DirNode

var
  directoryTree: DirList
  currentDir: DirNode = nil
  sumTotalSizes = 0

proc newDirNode(name: string): DirNode =
  new(result)
  result.name = name

proc find(node: DirNode, name: string): DirNode =
  for n in node.sub:
    if n.name == name:
      result = n
      break

proc calcDirSize(n: DirNode) =
  for sn in n.sub:
    calcDirSize(sn)
    n.size += sn.size
  if n.size <= 100_000:
    sumTotalSizes += n.size

for l in lines("input.txt"):
  var i = 0
  # Command
  if l[0] == '$' and l[1] == ' ':
    i = 2
    var command, arg: string
    i += parseUntil(l, command, ' ', i)
    inc(i)
    if i < len(l):
      arg = l[i..^1]

    case command
    of "cd":
      case arg
      of "/":
        if isNil(directoryTree.head):
          directoryTree.head = newDirNode("/")
        currentDir = directoryTree.head
      of "..":
        if not isNil(currentDir.top):
          currentDir = currentDir.top
      else:
        let f = find(currentDir, arg)
        if not isNil(f):
          currentDir = f
        else:
          echo fmt"directory '{arg}' not found in '{currentDir.name}'"
    of "ls":
      discard
    else:
      discard
  else:
    # ls print
    var
      name: string
      size: int
    # is a directory
    if scanf(l, "dir $w", name):
      let dir = newDirNode(name)
      dir.top = currentDir
      add(currentDir.sub, dir)
    # is a file
    elif scanf(l, "$i $w", size, name):
      currentDir.size += size
    else:
      echo fmt"Bad line: {l}"

calcDirSize(directoryTree.head)

echo "Answer: ", sumTotalSizes
