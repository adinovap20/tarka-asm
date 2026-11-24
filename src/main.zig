//! This module will contain entry point of my tarkasm CLI. However, for now,
//! it contains the hardcoded testing logic. Eventually, command line argument parsing
//! and related logic will be added in this file.

const std = @import("std");
const elf = @import("format/elf/elf.zig");

/// entry point for the program
pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const machine_code = [_]u8{
        0xbf, 0x2a, 0x00, 0x00, 0x00,
        0xb8, 0x3c, 0x00, 0x00, 0x00,
        0x0f, 0x05,
    };

    var executable = elf.Executable.init(&machine_code);
    defer executable.deinit();

    try executable.write_to_file(io, "assets/program");
}
