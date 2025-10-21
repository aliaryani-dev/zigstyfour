const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const b64 = @import("base64.zig");

pub fn main() !void {
    var memory_buffer:[1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();
    
    const text = "Testing some more stuff";
    const etext = "VGVzdGluZyBzb21lIG1vcmUgc3R1ZmY=";
    const base64 = b64.Base64.init();

    const encoded_text = try base64.encode(allocator, text);
    const decoded_text = try base64.decode(allocator, etext);
    
    try stdout.print("Encoded Text: {s}\n", .{encoded_text});
    try stdout.print("Decoded Text: {s}\n", .{decoded_text});

    try stdout.flush();

}
