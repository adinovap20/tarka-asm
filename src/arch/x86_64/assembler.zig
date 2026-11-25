//! This module holds the x86-64 assembler structure and functions

const std = @import("std");

/// Assembler for x86_64
pub const Assembler = struct {
    allocator: std.mem.Allocator,
    output_buf: std.ArrayList(u8) = .empty,

    /// initializes the assembler
    pub fn init(allocator: std.mem.Allocator) Assembler {
        return .{ .allocator = allocator };
    }

    /// deinitializes the assembler
    pub fn deinit(self: *Assembler) void {
        self.output_buf.deinit(self.allocator);
    }

    /// assembles and returns the slice of bytes
    pub fn assemble(self: *Assembler) []u8 {
        return self.output_buf.items;
    }
};
