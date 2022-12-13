import Foundation

enum Packet {
    case list([Packet])
    case integer(Int)
}

extension Packet: Comparable {
    static func compare(left: Packet, right: Packet) -> Int {
        switch (left, right) {
        case let (.integer(left_int), .integer(right_int)):
            return left_int - right_int
        case let (.list(left_list), .list(right_list)):
            var left_iter = left_list.makeIterator()
            var right_iter = right_list.makeIterator()

            var left_elt = left_iter.next()
            var right_elt = right_iter.next()

            while left_elt != nil && right_elt != nil {
                let order = compare(left: left_elt!, right: right_elt!)
                if order != 0 {
                    return order
                }

                left_elt = left_iter.next()
                right_elt = right_iter.next()
            }

            if left_elt == nil && right_elt == nil {
                return 0
            } else if left_elt == nil {
                return -1
            } else {
                return 1
            }
        case (.integer, .list):
            return compare(left: Packet.list([left]), right: right)
        case (.list, .integer):
            return compare(left: left, right: Packet.list([right]))
        }
    }

    static func <(left: Packet, right: Packet) -> Bool {
        return compare(left: left, right: right) < 0
    }

    static func ==(left: Packet, right: Packet) -> Bool {
        return compare(left: left, right: right) == 0
    }
}

func parseList(list: Substring) -> Packet {
    var packet: [Packet] = []
    var pos = list.startIndex

    func advance() {
        pos = list.index(after: pos)
    }

    while pos < list.endIndex {
        if list[pos].isNumber {
            let integer_start = pos
            repeat {
                advance()
            } while pos < list.endIndex && list[pos].isNumber

            packet.append(Packet.integer(Int(list[integer_start ..< pos])!))
        } else if list[pos] == "[" {
            advance()
            let sub_list_start = pos
            var depth = 0
            while list[pos] != "]" || depth > 0 {
                if list[pos] == "[" {
                    depth += 1
                } else if list[pos] == "]" {
                    depth -= 1
                }

                advance()
            }

            packet.append(parseList(list: list[sub_list_start ..< pos]))
        } else {
            advance()
        }
    }

    return Packet.list(packet)
}

func partOne(input: String) -> Int {
    let lines = input.split(separator: "\n")

    var res = 0

    for i in stride(from: 0, to: lines.count, by: 2) {
        let left_start = lines[i].index(after: lines[i].startIndex)
        let left_end = lines[i].index(before: lines[i].endIndex)
        let left = lines[i][left_start ..< left_end]

        let right_start = lines[i + 1].index(after: lines[i + 1].startIndex)
        let right_end = lines[i + 1].index(before: lines[i + 1].endIndex)
        let right = lines[i + 1][right_start ..< right_end]

        let left_packet = parseList(list: left)
        let right_packet = parseList(list: right)

        if left_packet < right_packet {
            res += i / 2 + 1
        }
    }

    return res
}

func partTwo(input: String) -> Int {
    let lines = input.split(separator: "\n")

    var packets: [Packet] = []

    for line in lines {
        let line_start = line.index(after: line.startIndex)
        let line_end = line.index(before: line.endIndex)
        let line = line[line_start ..< line_end]

        let packet = parseList(list: line)

        packets.append(packet)
    }

    let first_divider = Packet.list([Packet.list([Packet.integer(2)])])
    let second_divider = Packet.list([Packet.list([Packet.integer(6)])])

    packets.append(first_divider)
    packets.append(second_divider)

    packets.sort()

    let first_divider_index = packets.firstIndex(of: first_divider)! + 1
    let second_divider_index = packets.firstIndex(of: second_divider)! + 1

    return first_divider_index * second_divider_index
}

let file = "input.txt"

let url = URL(fileURLWithPath: file)

let input = try String(contentsOf: url)

print("part one: \(partOne(input: input))")
print("part two: \(partTwo(input: input))")
