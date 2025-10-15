const helpers = @import("helpers.zig");
/// Control and Status
/// GENERAL CONSTRAINTS:
/// Reference clock frequency min=5MHz, max=800MHz
/// Feedback divider min=16, max=320
/// VCO frequency min=750MHz, max=1600MHz
pub const CS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002c000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Passes the reference clock to the output instead of the divided VCO. The VCO continues to run so the user can switch between the reference clock and the divided VCO but the output will glitch when doing so.
        pub fn BYPASS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Divides the PLL input reference clock.
        /// Behaviour is undefined for div=0.
        /// PLL output will be unpredictable during refdiv changes, wait for lock=1 before using it.
        pub fn REFDIV(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 6),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn LOCK(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn BYPASS(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn REFDIV(self: Result) u6 {
            const mask = comptime helpers.generateMask(0, 6);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Passes the reference clock to the output instead of the divided VCO. The VCO continues to run so the user can switch between the reference clock and the divided VCO but the output will glitch when doing so.
    pub fn BYPASS(v: u1) Value {
        return Value.BYPASS(.{}, v);
    }
    /// Divides the PLL input reference clock.
    /// Behaviour is undefined for div=0.
    /// PLL output will be unpredictable during refdiv changes, wait for lock=1 before using it.
    pub fn REFDIV(v: u6) Value {
        return Value.REFDIV(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Controls the PLL power modes.
pub const PWR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002c004),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// PLL VCO powerdown
        /// To save power set high when PLL output not required or bypass=1.
        pub fn VCOPD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// PLL post divider powerdown
        /// To save power set high when PLL output not required or bypass=1.
        pub fn POSTDIVPD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// PLL DSM powerdown
        /// Nothing is achieved by setting this low.
        pub fn DSMPD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// PLL powerdown
        /// To save power set high when PLL output not required.
        pub fn PD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn VCOPD(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn POSTDIVPD(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DSMPD(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PD(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// PLL VCO powerdown
    /// To save power set high when PLL output not required or bypass=1.
    pub fn VCOPD(v: u1) Value {
        return Value.VCOPD(.{}, v);
    }
    /// PLL post divider powerdown
    /// To save power set high when PLL output not required or bypass=1.
    pub fn POSTDIVPD(v: u1) Value {
        return Value.POSTDIVPD(.{}, v);
    }
    /// PLL DSM powerdown
    /// Nothing is achieved by setting this low.
    pub fn DSMPD(v: u1) Value {
        return Value.DSMPD(.{}, v);
    }
    /// PLL powerdown
    /// To save power set high when PLL output not required.
    pub fn PD(v: u1) Value {
        return Value.PD(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Feedback divisor
/// (note: this PLL does not support fractional division)
pub const FBDIV_INT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002c008),
    pub fn write(self: @This(), v: u12) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u12 {
        const mask = comptime helpers.generateMask(0, 12);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Controls the PLL post dividers for the primary output
/// (note: this PLL does not have a secondary output)
/// the primary output is driven from VCO divided by postdiv1*postdiv2
pub const PRIM = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002c00c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// divide by 1-7
        pub fn POSTDIV1(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 19),
            };
        }
        /// divide by 1-7
        pub fn POSTDIV2(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 15),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn POSTDIV1(self: Result) u3 {
            const mask = comptime helpers.generateMask(16, 19);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn POSTDIV2(self: Result) u3 {
            const mask = comptime helpers.generateMask(12, 15);
            return @intCast((self.val & mask) >> 12);
        }
    };
    /// divide by 1-7
    pub fn POSTDIV1(v: u3) Value {
        return Value.POSTDIV1(.{}, v);
    }
    /// divide by 1-7
    pub fn POSTDIV2(v: u3) Value {
        return Value.POSTDIV2(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const PLL_USB_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4002c000),

    /// Control and Status
    /// GENERAL CONSTRAINTS:
    /// Reference clock frequency min=5MHz, max=800MHz
    /// Feedback divider min=16, max=320
    /// VCO frequency min=750MHz, max=1600MHz
    CS: CS = .{},
    /// Controls the PLL power modes.
    PWR: PWR = .{},
    /// Feedback divisor
    /// (note: this PLL does not support fractional division)
    FBDIV_INT: FBDIV_INT = .{},
    /// Controls the PLL post dividers for the primary output
    /// (note: this PLL does not have a secondary output)
    /// the primary output is driven from VCO divided by postdiv1*postdiv2
    PRIM: PRIM = .{},
};
pub const PLL_USB = PLL_USB_p{};
