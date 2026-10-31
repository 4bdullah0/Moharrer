const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    _ = io;
    std.debug.print("يا الله\n", .{});
}
