//! This module holds the x86-64 assembler structure and functions

const std = @import("std");
const Register = @import("register.zig").Register;
const Reg64 = @import("register.zig").Reg64;

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

    /// TODO: Need to add support for reg32, reg16, reg8
    pub fn mov_reg_imm(self: *Assembler, reg: Register, imm: u64) !void {
        switch (reg) {
            .reg64 => {
                try self.mov_reg64_imm64(reg.reg64, imm);
            },
        }
    }

    /// TODO: need to add support for reg32, reg16, reg8
    pub fn mov_reg_reg(self: *Assembler, src: Register, dst: Register) !void {
        if (std.meta.activeTag(src) != std.meta.activeTag(dst)) {
            return error.UnequalRegisterWidth;
        }
        switch (src) {
            .reg64 => {
                try self.mov_reg64_reg64(src.reg64, dst.reg64);
            },
        }
    }

    // COMPLETED
    /// Syscall instruction
    pub fn syscall(self: *Assembler) !void {
        // 0x0F 0x05 is syscall instruction's machine code
        try self.output_buf.append(self.allocator, 0x0F);
        try self.output_buf.append(self.allocator, 0x05);
    }

    // COMPLETED
    /// move 64-bit value into 64 bit register
    fn mov_reg64_imm64(self: *Assembler, reg: Reg64, imm: u64) !void {
        // [REX prefix: 1 byte] [Opcode: 1 byte] [Immediate u64: 8 bytes, little endian]
        // This is REX Prefix - 0x48 for [RAX-RDI] and 0x49 for [R8-R15]
        const regid: u8 = @backingInt(reg);
        const rex_prefix: u8 = if (regid <= 7) 0x48 else 0x49;
        try self.output_buf.append(self.allocator, rex_prefix);

        // Opcode - 0xB8 + register number modulo 8
        const opcode: u8 = 0xB8 + regid % 8;
        try self.output_buf.append(self.allocator, opcode);

        // 8 byte immediate array
        var buf: [8]u8 = undefined;
        std.mem.writeInt(u64, &buf, imm, .little);
        try self.output_buf.appendSlice(self.allocator, &buf);
    }

    // COMPLETED
    /// mov a value from 1 64 bit register to other
    fn mov_reg64_reg64(self: *Assembler, src: Reg64, dst: Reg64) !void {
        const srcregid: u8 = @backingInt(src);
        const dstregid: u8 = @backingInt(dst);

        // [REX prefix: 1 byte] [Opcode: 0x89] [ModR/M byte: 1 byte]
        // This is REX prefix - start with 0x48 for 64 bit operands,
        // if src >= 8 -> REX.R = 1 (add 4) & if dst >= 8 -> REX.B = 1 (add 1)
        var rex_prefix: u8 = 0x48;
        if (srcregid >= 8) rex_prefix += 4;
        if (dstregid >= 8) rex_prefix += 1;
        try self.output_buf.append(self.allocator, rex_prefix);

        // Opcode -> 0x89
        try self.output_buf.append(self.allocator, 0x89);

        // ModR/M byte -> 1 byte
        // mod = 3 -> register direct mode
        // reg_bits -> src & 7
        // rm_bits -> dst & 7
        const mod_rm: u8 = 0xC0 | ((srcregid & 7) << 3 | (dstregid & 7));
        try self.output_buf.append(self.allocator, mod_rm);
    }
};
