const std = @import("std");

fn getLine(reader: anytype, buffer: []u8) ?[]const u8 {
    var line = (reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    ) catch unreachable) orelse return null;

    return line;
}

fn distinct(window: []const u8) bool {
    var j : usize = window.len - 1;
    while (j > 0) : (j -= 1) {
        var k : usize = 0;
        while (k < j) : (k += 1) {
            if (window[k] == window[j]) {
                return false;
            }
        }
    }

    return true;
}

fn solve(file: []const u8, window_size: usize) usize {
    var input = std.fs.cwd().openFile(file, .{}) catch unreachable;

    defer input.close();

    var buf: [4096]u8 = undefined;

    var line = getLine(input.reader(), &buf).?;

    var i : usize = window_size - 1;
    while (i <= line.len) : (i += 1) {
        if (distinct(line[i-(window_size-1)..i+1])) {
            return i + 1;
        }
    }

    return 0;
}

fn part_one(file: []const u8) usize {
    return solve(file, 4);
}

fn part_two(file: []const u8) usize {
    return solve(file, 14);
}

pub fn main() void {
    const file = "inputs/input.txt";

    std.debug.print("part one: {d}\n", .{part_one(file)});
    std.debug.print("part two: {d}\n", .{part_two(file)});
}
