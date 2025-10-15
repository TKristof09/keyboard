const rp = @import("chip/rp2040.zig");

pub const Xosc = struct {
    pub fn init() void {
        // 47 taken from formula from the datasheet section 2.16.3
        rp.peripherals.XOSC.STARTUP.write(comptime rp.XOSC.STARTUP.DELAY(47));
        rp.peripherals.XOSC.CTRL.write(comptime rp.XOSC.CTRL.FREQ_RANGE(.@"1_15MHZ"));

        rp.peripherals.XOSC.CTRL.write(comptime rp.XOSC.CTRL.ENABLE(.ENABLE));

        while (rp.peripherals.XOSC.STATUS.read().STABLE() == 0) {}
    }
};
