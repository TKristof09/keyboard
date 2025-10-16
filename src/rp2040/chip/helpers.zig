const std = @import("std");
pub inline fn toU32(val: anytype) u32 {
    switch (@typeInfo(@TypeOf(val))) {
        .@"enum" => return @intFromEnum(val),
        .int => return @intCast(val),
        .comptime_int => return @intCast(val),
        else => unreachable,
    }
}

/// generate bit mask for start..end (end exclusive)
pub fn generateMask(comptime start: u8, comptime end: u8) u32 {
    comptime {
        if (end < start) @compileError("generateMask: end must be >= start");
        if (start >= 32) @compileError("generateMask: start must be < 32");
        if (end > 32) @compileError("generateMask: end must be <= 32");
        if (start == end) @compileError("generateMask: start and end must be different");
    }

    const width: u8 = end - start;
    if (width == 32) return 0xFFFF_FFFF;

    const ones = (@as(u32, 1) << width) - 1;
    return ones << start;
}
// the SIO on the rp2040 doesnt support these
// also the processor's registers don't support it either
pub inline fn hwAtomicClear(reg: *volatile u32, mask: u32) void {
    // SIO
    std.debug.assert(!(0xd0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xdfffffff));
    // Processor registers
    std.debug.assert(!(0xe0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xefffffff));
    // USB DPRAM
    std.debug.assert(!(0x50100000 < @intFromPtr(reg) and @intFromPtr(reg) < 0x50110000));

    const addr: *volatile u32 = @ptrFromInt(@intFromPtr(reg) + 0x3000);
    addr.* = mask;
}
pub inline fn hwAtomicSet(reg: *volatile u32, mask: u32) void {
    // SIO
    std.debug.assert(!(0xd0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xdfffffff));
    // Processor registers
    std.debug.assert(!(0xe0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xefffffff));
    // USB DPRAM
    std.debug.assert(!(0x50100000 < @intFromPtr(reg) and @intFromPtr(reg) < 0x50110000));

    const addr: *volatile u32 = @ptrFromInt(@intFromPtr(reg) + 0x2000);
    addr.* = mask;
}
pub inline fn hwAtomicXOR(reg: *volatile u32, mask: u32) void {
    // SIO
    std.debug.assert(!(0xd0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xdfffffff));
    // Processor registers
    std.debug.assert(!(0xe0000000 < @intFromPtr(reg) and @intFromPtr(reg) < 0xefffffff));
    // USB DPRAM
    std.debug.assert(!(0x50100000 < @intFromPtr(reg) and @intFromPtr(reg) < 0x50110000));

    const addr: *volatile u32 = @ptrFromInt(@intFromPtr(reg) + 0x1000);
    addr.* = mask;
}
// NOTE: this method allows safe concurrent modification of *different* bits of
// a register, but multiple concurrent access to the same bits is still unsafe.
pub inline fn hwWriteMasked(reg: *volatile u32, val: u32, mask: u32) void {
    const delta = reg.* ^ val;
    hwAtomicXOR(reg, delta & mask);
}
