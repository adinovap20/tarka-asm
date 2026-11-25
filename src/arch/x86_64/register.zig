//! This module holds the register related functionality for x86_64 architecture

/// Tagged union of different sized registers
pub const Register = union(enum) {
    reg64: Reg64,
};

///R64 enum is the 64-bit register
pub const Reg64 = enum(u8) {
    rax = 0,
    rcx = 1,
    rdx = 2,
    rbx = 3,
    rsp = 4,
    rbp = 5,
    rsi = 6,
    rdi = 7,
    r8 = 8,
    r9 = 9,
    r10 = 10,
    r11 = 11,
    r12 = 12,
    r13 = 13,
    r14 = 14,
    r15 = 15,
};
