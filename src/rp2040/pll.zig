const rp = @import("chip/rp2040.zig");
pub const PLLConfig = struct {
    fbdiv: u12,
    post_div1: u3,
    post_div2: u3,
};

pub fn setupSys(config: PLLConfig) void {
    // turn off and back on, not sure why is needed but the sdk does it
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_SYS(1));
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_SYS(0));

    // • Program the reference clock divider (is a divide by 1 in the RP2040 case) -- this is 1 at reset
    // • Program the feedback divider
    rp.peripherals.PLL_SYS.FBDIV_INT.write(config.fbdiv);
    // • Turn on the main power and VCO
    rp.peripherals.PLL_SYS.PWR.write(comptime rp.PLL_SYS.PWR.PD(0).VCOPD(0));
    // • Wait for the VCO to lock (i.e. keep its output frequency stable)
    while (rp.peripherals.PLL_SYS.CS.read().LOCK() == 0) {}
    // • Set up post dividers
    rp.peripherals.PLL_SYS.PRIM.write(rp.PLL_SYS.PRIM.POSTDIV1(config.post_div1).POSTDIV2(config.post_div2));
    // • Turn post dividers on
    rp.peripherals.PLL_SYS.PWR.write(comptime rp.PLL_SYS.PWR.POSTDIVPD(0));
}

pub fn setupUSB(config: PLLConfig) void {
    // turn off and back on, not sure why is needed but the sdk does it
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_USB(1));
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_USB(0));
    // • Program the reference clock divider (is a divide by 1 in the RP2040 case) -- this is 1 at reset
    // • Program the feedback divider
    rp.peripherals.PLL_USB.FBDIV_INT.write(config.fbdiv);
    // • Turn on the main power and VCO
    rp.peripherals.PLL_USB.PWR.write(comptime rp.PLL_USB.PWR.PD(0).VCOPD(0));
    // • Wait for the VCO to lock (i.e. keep its output frequency stable)
    while (rp.peripherals.PLL_USB.CS.read().LOCK() == 0) {}
    // • Set up post dividers
    rp.peripherals.PLL_USB.PRIM.write(rp.PLL_USB.PRIM.POSTDIV1(config.post_div1).POSTDIV2(config.post_div2));
    // • Turn post dividers on
    rp.peripherals.PLL_USB.PWR.write(comptime rp.PLL_USB.PWR.POSTDIVPD(0));
}
