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

const needUnusedSpace = 30_000_000

var
  directoryTree: DirList
  currentDir: DirNode = nil
  availableDiskSpace = 70_000_000
  bestDir: DirNode

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

proc seekBest(n: DirNode) =
  for sn in n.sub:
    seekBest(sn)
  if (n.size + availableDiskSpace) >= needUnusedSpace and n.size < bestDir.size:
    bestDir = n

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

availableDiskSpace -= directoryTree.head.size

bestDir = directoryTree.head

seekBest(directoryTree.head)

echo "Answer: ", bestDir.size
