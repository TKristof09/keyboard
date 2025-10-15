const helpers = @import("helpers.zig");
/// Crystal Oscillator Control
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40024000),
    const ENABLE_e = enum(u12) {
        DISABLE = 3358,
        ENABLE = 4011,
    };
    const FREQ_RANGE_e = enum(u12) {
        @"1_15MHZ" = 2720,
        RESERVED_1 = 2721,
        RESERVED_2 = 2722,
        RESERVED_3 = 2723,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// On power-up this field is initialised to DISABLE and the chip runs from the ROSC.
        /// If the chip has subsequently been programmed to run from the XOSC then DISABLE may lock-up the chip. If this is a concern then run the clk_ref from the ROSC and enable the clk_sys RESUS feature.
        /// The 12-bit code is intended to give some protection against accidental writes. An invalid setting will enable the oscillator.
        pub fn ENABLE(self: Value, v: ENABLE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 24),
            };
        }
        /// Frequency range. An invalid setting will retain the previous value. The actual value being used can be read from STATUS_FREQ_RANGE. This resets to 0xAA0 and cannot be changed.
        pub fn FREQ_RANGE(self: Value, v: FREQ_RANGE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 12),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) ENABLE_e {
            const mask = comptime helpers.generateMask(12, 24);
            const val: @typeInfo(ENABLE_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn FREQ_RANGE(self: Result) FREQ_RANGE_e {
            const mask = comptime helpers.generateMask(0, 12);
            const val: @typeInfo(FREQ_RANGE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// On power-up this field is initialised to DISABLE and the chip runs from the ROSC.
    /// If the chip has subsequently been programmed to run from the XOSC then DISABLE may lock-up the chip. If this is a concern then run the clk_ref from the ROSC and enable the clk_sys RESUS feature.
    /// The 12-bit code is intended to give some protection against accidental writes. An invalid setting will enable the oscillator.
    pub fn ENABLE(v: ENABLE_e) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Frequency range. An invalid setting will retain the previous value. The actual value being used can be read from STATUS_FREQ_RANGE. This resets to 0xAA0 and cannot be changed.
    pub fn FREQ_RANGE(v: FREQ_RANGE_e) Value {
        return Value.FREQ_RANGE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Crystal Oscillator Status
pub const STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40024004),
    const FREQ_RANGE_e = enum(u2) {
        @"1_15MHZ" = 0,
        RESERVED_1 = 1,
        RESERVED_2 = 2,
        RESERVED_3 = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An invalid value has been written to CTRL_ENABLE or CTRL_FREQ_RANGE or DORMANT
        pub fn BADWRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn STABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn BADWRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn ENABLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn FREQ_RANGE(self: Result) FREQ_RANGE_e {
            const mask = comptime helpers.generateMask(0, 2);
            const val: @typeInfo(FREQ_RANGE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// An invalid value has been written to CTRL_ENABLE or CTRL_FREQ_RANGE or DORMANT
    pub fn BADWRITE(v: u1) Value {
        return Value.BADWRITE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Crystal Oscillator pause control
pub const DORMANT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40024008),
    const DORMANT_e = enum(u32) {
        dormant = 1668246881,
        WAKE = 2002873189,
    };
    pub fn write(self: @This(), v: DORMANT_e) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn read(self: @This()) DORMANT_e {
        const mask = comptime helpers.generateMask(0, 32);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Controls the startup delay
pub const STARTUP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002400c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Multiplies the startup_delay by 4. This is of little value to the user given that the delay can be programmed directly.
        pub fn X4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// in multiples of 256*xtal_period. The reset value of 0xc4 corresponds to approx 50 000 cycles.
        pub fn DELAY(self: Value, v: u14) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 14),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn X4(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn DELAY(self: Result) u14 {
            const mask = comptime helpers.generateMask(0, 14);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Multiplies the startup_delay by 4. This is of little value to the user given that the delay can be programmed directly.
    pub fn X4(v: u1) Value {
        return Value.X4(.{}, v);
    }
    /// in multiples of 256*xtal_period. The reset value of 0xc4 corresponds to approx 50 000 cycles.
    pub fn DELAY(v: u14) Value {
        return Value.DELAY(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// A down counter running at the xosc frequency which counts to zero and stops.
/// To start the counter write a non-zero value.
/// Can be used for short software pauses when setting up time sensitive hardware.
pub const COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002401c),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Controls the crystal oscillator
pub const XOSC_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40024000),

    /// Crystal Oscillator Control
    CTRL: CTRL = .{},
    /// Crystal Oscillator Status
    STATUS: STATUS = .{},
    /// Crystal Oscillator pause control
    DORMANT: DORMANT = .{},
    /// Controls the startup delay
    STARTUP: STARTUP = .{},
    /// A down counter running at the xosc frequency which counts to zero and stops.
    /// To start the counter write a non-zero value.
    /// Can be used for short software pauses when setting up time sensitive hardware.
    COUNT: COUNT = .{},
};
pub const XOSC = XOSC_p{};
