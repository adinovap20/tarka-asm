//! This module will contain entry point of my tarkasm CLI. However, for now,
//! it contains the hardcoded testing logic. Eventually, command line argument parsing
//! and related logic will be added in this file.

const std = @import("std");
const elf = @import("format/elf/elf.zig");
const Assembler = @import("arch/x86_64/assembler.zig").Assembler;

/// entry point for the program
pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var assembler = Assembler.init(init.gpa);
    defer assembler.deinit();

    try assembler.mov_reg_imm(.{ .reg64 = .r8 }, 10);
    try assembler.mov_reg_imm(.{ .reg64 = .rdi }, 30);
    try assembler.mov_reg_imm(.{ .reg64 = .rax }, 60);
    try assembler.mov_reg_reg(.{ .reg64 = .rdi }, .{ .reg64 = .r8 });
    try assembler.syscall();
    const machine_code = assembler.assemble();

    var executable = elf.Executable.init(machine_code);
    defer executable.deinit();

    try executable.write_to_file(io, "assets/program");
}
