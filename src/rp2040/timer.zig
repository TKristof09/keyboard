const rp = @import("chip/rp2040.zig");
const std = @import("std");

// this isnt thread safe
fn readTimer() u64 {
    const l: u64 = @intCast(rp.peripherals.TIMER.TIMELR.read());
    const h: u64 = @intCast(rp.peripherals.TIMER.TIMEHR.read());
    return h << 32 | l;
}

pub fn busyWait(ms: u32) void {
    const start = readTimer();
    const delay_us = ms * 1000;
    while (readTimer() - start < delay_us) {}
}
