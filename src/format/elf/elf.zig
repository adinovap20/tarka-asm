//! This module exposes functionality for generating a minimal elf binary

const std = @import("std");
const ElfHeader = @import("elf_header.zig").ElfHeader;

/// This struct holds all the executable related functionality
pub const Executable = struct {
    /// holds the elf header
    elf_header: ElfHeader,

    /// holds the machine code to be written
    machine_code: []const u8,

    /// This function initializes an executable and returns it
    pub fn init(machine_code: []const u8) Executable {
        var elf_header = ElfHeader.init();
        elf_header.set_machine_code(machine_code);
        return .{ .elf_header = elf_header, .machine_code = machine_code };
    }

    /// This function deinitializes any memory allocated by the executable struct
    pub fn deinit(self: *Executable) void {
        std.debug.print("Size of elf binary: {d}\n", .{self.machine_code.len + @sizeOf(ElfHeader)});
    }

    /// writes the bytes to the file
    pub fn write_to_file(self: *Executable, io: std.Io, file_name: []const u8) !void {
        const dir = std.Io.Dir.cwd();
        const file = try dir.createFile(io, file_name, .{});
        defer file.close(io);

        var buffer: [4096]u8 = undefined;
        var writer = file.writerStreaming(io, &buffer);

        try writer.interface.writeAll(&self.elf_header.to_bytes());
        try writer.interface.writeAll(self.machine_code);
        try writer.interface.flush();
    }
};
