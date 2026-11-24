//! This module handles the program header of elf binary

/// program header structure
pub const ProgramHeader = struct {
    /// type of the segment: PT_LOAD = loadable segment
    p_type: [4]u8 = .{ 0x01, 0x00, 0x00, 0x00 },

    /// readable + writable = 5
    p_flags: [4]u8 = .{ 0x05, 0x00, 0x00, 0x00 },

    /// mapped region starts at what file offset
    p_offset: [8]u8 = .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// load this at which virtual address - 0x4000000
    p_vaddr: [8]u8 = .{ 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// physical address - ignored by linux
    p_paddr: [8]u8 = .{ 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// entire elf file size
    p_filesz: [8]u8 = .{ 0x84, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// memory size - same as file size
    p_memsz: [8]u8 = .{ 0x84, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// segments are aligned to 0x1000 - 4KiB
    p_align: [8]u8 = .{ 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// intializes the program header
    pub fn init() ProgramHeader {
        return .{};
    }

    /// modifies p_filesz and p_memsz as per the machine code size
    pub fn set_machine_code(self: *ProgramHeader, machine_code: []const u8) void {
        self.p_filesz = @as([8]u8, @bitCast(@as(u64, @intCast(machine_code.len))));
        self.p_memsz = self.p_filesz;
    }

    /// returns the 58 program header bytes directly
    pub fn to_bytes(self: *ProgramHeader) [56]u8 {
        var result: [56]u8 = undefined;

        @memcpy(result[0..4], &self.p_type);
        @memcpy(result[4..8], &self.p_flags);
        @memcpy(result[8..16], &self.p_offset);
        @memcpy(result[16..24], &self.p_vaddr);
        @memcpy(result[24..32], &self.p_paddr);
        @memcpy(result[32..40], &self.p_filesz);
        @memcpy(result[40..48], &self.p_memsz);
        @memcpy(result[48..56], &self.p_align);

        return result;
    }
};
