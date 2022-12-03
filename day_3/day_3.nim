import strutils

const file = "input.txt"

let
  input = readFile(file)
  lines = input.splitLines()

proc part_one(lines: seq[string]): int =
  var res = 0

  for items in lines:
    let
      middle = items.len div 2
      first = items[0..<middle]
      second = items[middle..<items.len]

    for item in first:
      if item in second:
        if item >= 'a' and item <= 'z':
          res += int(item) - int('a') + 1
        if item >= 'A' and item <= 'Z':
          res += int(item) - int('A') + 27
        break

  return res

proc part_two(lines: seq[string]): int =
  var res = 0

  for i in countup(0, lines.len - 1, 3):
    for item in lines[i]:
      if item in lines[i + 1] and item in lines[i + 2]:
        if item >= 'a' and item <= 'z':
          res += int(item) - int('a') + 1
        if item >= 'A' and item <= 'Z':
          res += int(item) - int('A') + 27
        break

  return res

echo "part one: ", part_one lines
echo "part two: ", part_two lines
