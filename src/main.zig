const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const base64 = @import("base64.zig");

pub fn main() !void {
    const input = "Hi";
    try stdout.print("{d}\n",.{input[0] >> 2});
    try stdout.flush();
}
