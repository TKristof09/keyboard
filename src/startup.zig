comptime {
    @export(&startup, .{
        .name = "_start",
    });
}

const rp = @import("rp2040/chip/rp2040.zig");
const interrupts = @import("rp2040/interrupts.zig");

extern fn main() void;

extern var __data_start__: anyopaque;
extern var __data_end__: anyopaque;
extern var __data_load__: anyopaque;
extern var __bss_start__: anyopaque;
extern var __bss_end__: anyopaque;

export fn startup() callconv(.c) void {
    // copy .data to ram
    const data_start: [*]u8 = @ptrCast(&__data_start__);
    const data_end: [*]u8 = @ptrCast(&__data_end__);
    const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
    const data_src: [*]const u8 = @ptrCast(&__data_load__);
    @memcpy(data_start[0..data_len], data_src[0..data_len]);

    // zero out .bss
    const bss_start: [*]u8 = @ptrCast(&__bss_start__);
    const bss_end: [*]u8 = @ptrCast(&__bss_end__);
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);
    @memset(bss_start[0..bss_len], 0);

    const loc: u32 = @intCast(@intFromPtr(&interrupts.vector_table));

    rp.peripherals.PPB.VTOR.write(@as(u24, @intCast(loc >> 8)) & 0xFFFFFF);
    main();
}
