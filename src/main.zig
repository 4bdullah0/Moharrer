///////////////////////////////////////////////////////////////////////////////
//
//                              Main function
//
///////////////////////////////////////////////////////////////////////////////

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    _ = io;

    var safe: std.heap.SafeAllocator = .init(std.heap.page_allocator, .{});

    const allocator, const is_safe = switch (builtin.mode) {
        .Debug, .ReleaseSafe => .{ safe.allocator(), true },
        .ReleaseFast, .ReleaseSmall => .{ std.heap.smp_allocator, false },
    };
    defer if (is_safe) std.debug.assert(safe.deinit() == 0);

    _ = allocator;

    var buf: [1]u8 = undefined;

    // loop until 'q' is pressed
    while (try terminal.posix.readChar(&buf) == 1 and buf[0] != 'q') {}
}

///////////////////////////////////////////////////////////////////////////////
//
//                          Panic Handler
//
///////////////////////////////////////////////////////////////////////////////

pub const panic = std.debug.FullPanic(crashed);

fn crashed(msg: []const u8, trace: ?usize) noreturn {
    std.debug.defaultPanic(msg, trace);
}

///////////////////////////////////////////////////////////////////////////////
//
//                              Constants, variables
//
///////////////////////////////////////////////////////////////////////////////

const std = @import("std");
const builtin = @import("builtin");
const Io = std.Io;
const terminal = @import("platform/terminal.zig");
