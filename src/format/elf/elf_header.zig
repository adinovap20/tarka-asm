//! This module contains elf header logic

const ProgramHeader = @import("program_header.zig").ProgramHeader;

/// This structure holds the representation of an elf header
pub const ElfHeader = struct {
    /// 0x7f followed by 'ELF' is magic number used by kernel to identify an ELF file
    magic: [4]u8 = .{ 0x7f, 0x45, 0x4c, 0x46 },

    /// 0x02 means 64-bit objects
    ei_class: u8 = 0x02,

    /// 0x01 means little-endian
    ei_data: u8 = 0x01,

    /// should always be 1 as it is the only version to exist ever
    ei_version: u8 = 0x01,

    /// os abi is unused here
    ei_osabi: u8 = 0x00,

    /// abi version is also unused here
    abiversion: u8 = 0x00,

    /// pads the identification block out of 16 bytes.
    padding: [7]u8 = .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// 2 means EXEC
    e_type: [2]u8 = .{ 0x02, 0x00 },

    /// 0x3E means x86-64
    e_machine: [2]u8 = .{ 0x3e, 0x00 },

    /// elf version again stored as 32 bits
    e_version: [4]u8 = .{ 0x01, 0x00, 0x00, 0x00 },

    /// virtual address where execution starts - 0x400078
    e_entry: [8]u8 = .{ 0x78, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// offset of program header - starts right after this header so 64
    e_phoff: [8]u8 = .{ 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// section header table - no for now as kernel does not require one to run the file
    e_shoff: [8]u8 = .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    /// processor specific flags - nothing for now
    e_flags: [4]u8 = .{ 0x00, 0x00, 0x00, 0x00 },

    /// elf header size - this header is 64 bytes
    e_ehsize: [2]u8 = .{ 0x40, 0x00 },

    /// each program header size - 56 bytes
    e_phentsize: [2]u8 = .{ 0x38, 0x00 },

    /// number of program headers - 1 for now
    e_phnum: [2]u8 = .{ 0x01, 0x00 },

    /// each section header size - 0 bytes in this case
    e_shentsize: [2]u8 = .{ 0x00, 0x00 },

    /// number of section headers - 0 in our case
    e_shnum: [2]u8 = .{ 0x00, 0x00 },

    /// index of the section header string table - 0 in our case
    e_shstrndx: [2]u8 = .{ 0x00, 0x00 },

    /// program header
    program_header: ProgramHeader = ProgramHeader.init(),

    /// initializes the elf header structure
    pub fn init() ElfHeader {
        return .{};
    }

    /// sets the program header according to our machine code
    pub fn set_machine_code(self: *ElfHeader, machine_code: []const u8) void {
        self.program_header.set_machine_code(machine_code);
    }

    /// converts the elf header into 120 byte machine code
    pub fn to_bytes(self: *ElfHeader) [120]u8 {
        var result: [120]u8 = undefined;

        @memcpy(result[0..4], &self.magic);
        result[4] = self.ei_class;
        result[5] = self.ei_data;
        result[6] = self.ei_version;
        result[7] = self.ei_osabi;
        result[8] = self.abiversion;
        @memcpy(result[9..16], &self.padding);
        @memcpy(result[16..18], &self.e_type);
        @memcpy(result[18..20], &self.e_machine);
        @memcpy(result[20..24], &self.e_version);
        @memcpy(result[24..32], &self.e_entry);
        @memcpy(result[32..40], &self.e_phoff);
        @memcpy(result[40..48], &self.e_shoff);
        @memcpy(result[48..52], &self.e_flags);
        @memcpy(result[52..54], &self.e_ehsize);
        @memcpy(result[54..56], &self.e_phentsize);
        @memcpy(result[56..58], &self.e_phnum);
        @memcpy(result[58..60], &self.e_shentsize);
        @memcpy(result[60..62], &self.e_shnum);
        @memcpy(result[62..64], &self.e_shstrndx);
        @memcpy(result[64..120], &self.program_header.to_bytes());

        return result;
    }
};
