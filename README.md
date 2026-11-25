# Tarka-ASM

> [!WARNING]
> **IN PROGRESS**: This project is currently in active development.

## Overview

This is a fun learning project which I had started to experiment with the [zig programming language](https://ziglang.org/). This project aims to expose some assembler apis which other zig applications can call. Eventually, I wanted to write a frontend + backend from scratch for my own compiler - this repo acts as a first step towards that goal.

Right now, it only supports `x86_64` architecture and supports only generation of `elf` executable. Eventually, I will add other backends as I learn these things and understand them properly.

These are the supported methods right now:

- `mov_reg64_imm64`
- `mov_reg64_reg64`
- `syscall`
- `add_reg64_reg64`
- `or_reg64_reg64`
- `adc_reg64_reg64`
- `sbb_reg64_reg64`
- `and_reg64_reg64`
- `sub_reg64_reg64`
- `xor_reg64_reg64`
- `cmp_reg64_reg64`

Only, 64-bit register support is there yet! But I eventually plan to add all later.

## Upcoming Milestones to Pursue

The upcoming tasks of this learning excercise are thus:

- [ ] Add label and jump support
- [ ] Stack related push, pop operations need to be added
- [ ] Memory operands need to be added so that the assembler can read and write to the stack slots

## Build yourself

The project uses [zig programming language](https://ziglang.org/) with version 0.17.1. Make sure to install it.

cd into this project folder and just run the following to build:

```bash
zig build
```

It will generate zig-out/bin/tarkasm or zig-out/bin/tarkasm.exe according to your operating system.

Currently, main function contains hardcoded things - I need to write a lexer to parse assembly files as text and call the api functions eventually. But right now, everything stays in main :)

> No agentic AI was used while writing this code! I've only chatted with AI to understand the low level concepts of machine code and to get little help - outside of Neovim :)


