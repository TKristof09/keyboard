const helpers = @import("helpers.zig");
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_GPOUT0_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008000),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const DC50: u32 = helpers.generateMask(12, 13);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 9);
    };
    const AUXSRC_e = enum(u4) {
        clksrc_pll_sys = 0,
        clksrc_gpin0 = 1,
        clksrc_gpin1 = 2,
        clksrc_pll_usb = 3,
        rosc_clksrc = 4,
        xosc_clksrc = 5,
        clk_sys = 6,
        clk_usb = 7,
        clk_adc = 8,
        clk_rtc = 9,
        clk_ref = 10,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Enables duty cycle correction for odd divisors
        pub fn DC50(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 9),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DC50(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 9);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Enables duty cycle correction for odd divisors
    pub fn DC50(v: u1) Value {
        return Value.DC50(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_GPOUT0_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008004),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_GPOUT0_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008008),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_GPOUT1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000800c),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const DC50: u32 = helpers.generateMask(12, 13);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 9);
    };
    const AUXSRC_e = enum(u4) {
        clksrc_pll_sys = 0,
        clksrc_gpin0 = 1,
        clksrc_gpin1 = 2,
        clksrc_pll_usb = 3,
        rosc_clksrc = 4,
        xosc_clksrc = 5,
        clk_sys = 6,
        clk_usb = 7,
        clk_adc = 8,
        clk_rtc = 9,
        clk_ref = 10,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Enables duty cycle correction for odd divisors
        pub fn DC50(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 9),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DC50(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 9);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Enables duty cycle correction for odd divisors
    pub fn DC50(v: u1) Value {
        return Value.DC50(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_GPOUT1_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008010),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_GPOUT1_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008014),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_GPOUT2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008018),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const DC50: u32 = helpers.generateMask(12, 13);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 9);
    };
    const AUXSRC_e = enum(u4) {
        clksrc_pll_sys = 0,
        clksrc_gpin0 = 1,
        clksrc_gpin1 = 2,
        clksrc_pll_usb = 3,
        rosc_clksrc_ph = 4,
        xosc_clksrc = 5,
        clk_sys = 6,
        clk_usb = 7,
        clk_adc = 8,
        clk_rtc = 9,
        clk_ref = 10,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Enables duty cycle correction for odd divisors
        pub fn DC50(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 9),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DC50(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 9);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Enables duty cycle correction for odd divisors
    pub fn DC50(v: u1) Value {
        return Value.DC50(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_GPOUT2_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000801c),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_GPOUT2_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008020),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_GPOUT3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008024),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const DC50: u32 = helpers.generateMask(12, 13);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 9);
    };
    const AUXSRC_e = enum(u4) {
        clksrc_pll_sys = 0,
        clksrc_gpin0 = 1,
        clksrc_gpin1 = 2,
        clksrc_pll_usb = 3,
        rosc_clksrc_ph = 4,
        xosc_clksrc = 5,
        clk_sys = 6,
        clk_usb = 7,
        clk_adc = 8,
        clk_rtc = 9,
        clk_ref = 10,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Enables duty cycle correction for odd divisors
        pub fn DC50(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 9),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DC50(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 9);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Enables duty cycle correction for odd divisors
    pub fn DC50(v: u1) Value {
        return Value.DC50(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_GPOUT3_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008028),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_GPOUT3_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000802c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_REF_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008030),
    pub const FieldMasks = struct {
        pub const AUXSRC: u32 = helpers.generateMask(5, 7);
        pub const SRC: u32 = helpers.generateMask(0, 2);
    };
    const AUXSRC_e = enum(u2) {
        clksrc_pll_usb = 0,
        clksrc_gpin0 = 1,
        clksrc_gpin1 = 2,
    };
    const SRC_e = enum(u2) {
        rosc_clksrc_ph = 0,
        clksrc_clk_ref_aux = 1,
        xosc_clksrc = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 7),
            };
        }
        /// Selects the clock source glitchlessly, can be changed on-the-fly
        pub fn SRC(self: Value, v: SRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 7);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn SRC(self: Result) SRC_e {
            const mask = comptime helpers.generateMask(0, 2);
            const val: @typeInfo(SRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    /// Selects the clock source glitchlessly, can be changed on-the-fly
    pub fn SRC(v: SRC_e) Value {
        return Value.SRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_REF_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008034),
    pub fn write(self: @This(), v: u2) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 8, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u2 {
        const mask = comptime helpers.generateMask(8, 10);
        return @intCast((self.reg.* & mask) >> 8);
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_REF_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008038),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_SYS_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000803c),
    pub const FieldMasks = struct {
        pub const AUXSRC: u32 = helpers.generateMask(5, 8);
        pub const SRC: u32 = helpers.generateMask(0, 1);
    };
    const AUXSRC_e = enum(u3) {
        clksrc_pll_sys = 0,
        clksrc_pll_usb = 1,
        rosc_clksrc = 2,
        xosc_clksrc = 3,
        clksrc_gpin0 = 4,
        clksrc_gpin1 = 5,
    };
    const SRC_e = enum(u1) {
        clk_ref = 0,
        clksrc_clk_sys_aux = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 8),
            };
        }
        /// Selects the clock source glitchlessly, can be changed on-the-fly
        pub fn SRC(self: Value, v: SRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 8);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn SRC(self: Result) SRC_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(SRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    /// Selects the clock source glitchlessly, can be changed on-the-fly
    pub fn SRC(v: SRC_e) Value {
        return Value.SRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_SYS_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008040),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_SYS_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008044),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_PERI_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008048),
    pub const FieldMasks = struct {
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 8);
    };
    const AUXSRC_e = enum(u3) {
        clk_sys = 0,
        clksrc_pll_sys = 1,
        clksrc_pll_usb = 2,
        rosc_clksrc_ph = 3,
        xosc_clksrc = 4,
        clksrc_gpin0 = 5,
        clksrc_gpin1 = 6,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 8);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_PERI_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000804c),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_PERI_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008050),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_USB_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008054),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 8);
    };
    const AUXSRC_e = enum(u3) {
        clksrc_pll_usb = 0,
        clksrc_pll_sys = 1,
        rosc_clksrc_ph = 2,
        xosc_clksrc = 3,
        clksrc_gpin0 = 4,
        clksrc_gpin1 = 5,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 8);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_USB_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008058),
    pub fn write(self: @This(), v: u2) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 8, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u2 {
        const mask = comptime helpers.generateMask(8, 10);
        return @intCast((self.reg.* & mask) >> 8);
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_USB_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000805c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_ADC_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008060),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 8);
    };
    const AUXSRC_e = enum(u3) {
        clksrc_pll_usb = 0,
        clksrc_pll_sys = 1,
        rosc_clksrc_ph = 2,
        xosc_clksrc = 3,
        clksrc_gpin0 = 4,
        clksrc_gpin1 = 5,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 8);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_ADC_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008064),
    pub fn write(self: @This(), v: u2) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 8, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(8, 10);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u2 {
        const mask = comptime helpers.generateMask(8, 10);
        return @intCast((self.reg.* & mask) >> 8);
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_ADC_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008068),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock control, can be changed on-the-fly (except for auxsrc)
pub const CLK_RTC_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000806c),
    pub const FieldMasks = struct {
        pub const NUDGE: u32 = helpers.generateMask(20, 21);
        pub const PHASE: u32 = helpers.generateMask(16, 18);
        pub const ENABLE: u32 = helpers.generateMask(11, 12);
        pub const KILL: u32 = helpers.generateMask(10, 11);
        pub const AUXSRC: u32 = helpers.generateMask(5, 8);
    };
    const AUXSRC_e = enum(u3) {
        clksrc_pll_usb = 0,
        clksrc_pll_sys = 1,
        rosc_clksrc_ph = 2,
        xosc_clksrc = 3,
        clksrc_gpin0 = 4,
        clksrc_gpin1 = 5,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
        /// This can be done at any time
        pub fn NUDGE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        /// This delays the enable signal by up to 3 cycles of the input clock
        /// This must be set before the clock is enabled to have any effect
        pub fn PHASE(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        /// Starts and stops the clock generator cleanly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Asynchronously kills the clock generator
        pub fn KILL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Selects the auxiliary clock source, will glitch when switching
        pub fn AUXSRC(self: Value, v: AUXSRC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NUDGE(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn PHASE(self: Result) u2 {
            const mask = comptime helpers.generateMask(16, 18);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KILL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn AUXSRC(self: Result) AUXSRC_e {
            const mask = comptime helpers.generateMask(5, 8);
            const val: @typeInfo(AUXSRC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
    };
    /// An edge on this signal shifts the phase of the output by 1 cycle of the input clock
    /// This can be done at any time
    pub fn NUDGE(v: u1) Value {
        return Value.NUDGE(.{}, v);
    }
    /// This delays the enable signal by up to 3 cycles of the input clock
    /// This must be set before the clock is enabled to have any effect
    pub fn PHASE(v: u2) Value {
        return Value.PHASE(.{}, v);
    }
    /// Starts and stops the clock generator cleanly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Asynchronously kills the clock generator
    pub fn KILL(v: u1) Value {
        return Value.KILL(.{}, v);
    }
    /// Selects the auxiliary clock source, will glitch when switching
    pub fn AUXSRC(v: AUXSRC_e) Value {
        return Value.AUXSRC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Clock divisor, can be changed on-the-fly
pub const CLK_RTC_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008070),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 32);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer component of the divisor, 0 -&gt; divide by 2^16
        pub fn INT(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// Fractional component of the divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer component of the divisor, 0 -&gt; divide by 2^16
    pub fn INT(v: u24) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional component of the divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates which SRC is currently selected by the glitchless mux (one-hot).
pub const CLK_RTC_SELECTED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008074),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const CLK_SYS_RESUS_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008078),
    pub const FieldMasks = struct {
        pub const CLEAR: u32 = helpers.generateMask(16, 17);
        pub const FRCE: u32 = helpers.generateMask(12, 13);
        pub const ENABLE: u32 = helpers.generateMask(8, 9);
        pub const TIMEOUT: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// For clearing the resus after the fault that triggered it has been corrected
        pub fn CLEAR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// Force a resus, for test purposes only
        pub fn FRCE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Enable resus
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// This is expressed as a number of clk_ref cycles
        /// and must be &gt;= 2x clk_ref_freq/min_clk_tst_freq
        pub fn TIMEOUT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CLEAR(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FRCE(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn TIMEOUT(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// For clearing the resus after the fault that triggered it has been corrected
    pub fn CLEAR(v: u1) Value {
        return Value.CLEAR(.{}, v);
    }
    /// Force a resus, for test purposes only
    pub fn FRCE(v: u1) Value {
        return Value.FRCE(.{}, v);
    }
    /// Enable resus
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This is expressed as a number of clk_ref cycles
    /// and must be &gt;= 2x clk_ref_freq/min_clk_tst_freq
    pub fn TIMEOUT(v: u8) Value {
        return Value.TIMEOUT(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const CLK_SYS_RESUS_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000807c),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Reference clock frequency in kHz
pub const FC0_REF_KHZ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008080),
    pub fn write(self: @This(), v: u20) void {
        const mask = comptime helpers.generateMask(0, 20);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 20);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 20);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u20 {
        const mask = comptime helpers.generateMask(0, 20);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Minimum pass frequency in kHz. This is optional. Set to 0 if you are not using the pass/fail flags
pub const FC0_MIN_KHZ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008084),
    pub fn write(self: @This(), v: u25) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u25 {
        const mask = comptime helpers.generateMask(0, 25);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Maximum pass frequency in kHz. This is optional. Set to 0x1ffffff if you are not using the pass/fail flags
pub const FC0_MAX_KHZ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008088),
    pub fn write(self: @This(), v: u25) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 25);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u25 {
        const mask = comptime helpers.generateMask(0, 25);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Delays the start of frequency counting to allow the mux to settle
/// Delay is measured in multiples of the reference clock period
pub const FC0_DELAY = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000808c),
    pub fn write(self: @This(), v: u3) void {
        const mask = comptime helpers.generateMask(0, 3);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 3);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 3);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u3 {
        const mask = comptime helpers.generateMask(0, 3);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// The test interval is 0.98us * 2**interval, but let&#39;s call it 1us * 2**interval
/// The default gives a test interval of 250us
pub const FC0_INTERVAL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008090),
    pub fn write(self: @This(), v: u4) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u4 {
        const mask = comptime helpers.generateMask(0, 4);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Clock sent to frequency counter, set to 0 when not required
/// Writing to this register initiates the frequency count
pub const FC0_SRC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008094),
    const FC0_SRC_e = enum(u8) {
        NULL = 0,
        pll_sys_clksrc_primary = 1,
        pll_usb_clksrc_primary = 2,
        rosc_clksrc = 3,
        rosc_clksrc_ph = 4,
        xosc_clksrc = 5,
        clksrc_gpin0 = 6,
        clksrc_gpin1 = 7,
        clk_ref = 8,
        clk_sys = 9,
        clk_peri = 10,
        clk_usb = 11,
        clk_adc = 12,
        clk_rtc = 13,
    };
    pub fn write(self: @This(), v: FC0_SRC_e) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) FC0_SRC_e {
        const mask = comptime helpers.generateMask(0, 8);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Frequency counter status
pub const FC0_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40008098),
    pub const FieldMasks = struct {
        pub const DIED: u32 = helpers.generateMask(28, 29);
        pub const FAST: u32 = helpers.generateMask(24, 25);
        pub const SLOW: u32 = helpers.generateMask(20, 21);
        pub const FAIL: u32 = helpers.generateMask(16, 17);
        pub const WAITING: u32 = helpers.generateMask(12, 13);
        pub const RUNNING: u32 = helpers.generateMask(8, 9);
        pub const DONE: u32 = helpers.generateMask(4, 5);
        pub const PASS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn DIED(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn FAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn FAIL(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn WAITING(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn RUNNING(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DONE(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn PASS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Result of frequency measurement, only valid when status_done=1
pub const FC0_RESULT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000809c),
    pub const FieldMasks = struct {
        pub const KHZ: u32 = helpers.generateMask(5, 30);
        pub const FRAC: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn KHZ(self: Result) u25 {
            const mask = comptime helpers.generateMask(5, 30);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn FRAC(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// enable clock in wake mode
pub const WAKE_EN0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080a0),
    pub const FieldMasks = struct {
        pub const CLK_SYS_SRAM3: u32 = helpers.generateMask(31, 32);
        pub const CLK_SYS_SRAM2: u32 = helpers.generateMask(30, 31);
        pub const CLK_SYS_SRAM1: u32 = helpers.generateMask(29, 30);
        pub const CLK_SYS_SRAM0: u32 = helpers.generateMask(28, 29);
        pub const CLK_SYS_SPI1: u32 = helpers.generateMask(27, 28);
        pub const CLK_PERI_SPI1: u32 = helpers.generateMask(26, 27);
        pub const CLK_SYS_SPI0: u32 = helpers.generateMask(25, 26);
        pub const CLK_PERI_SPI0: u32 = helpers.generateMask(24, 25);
        pub const CLK_SYS_SIO: u32 = helpers.generateMask(23, 24);
        pub const CLK_SYS_RTC: u32 = helpers.generateMask(22, 23);
        pub const CLK_RTC_RTC: u32 = helpers.generateMask(21, 22);
        pub const CLK_SYS_ROSC: u32 = helpers.generateMask(20, 21);
        pub const CLK_SYS_ROM: u32 = helpers.generateMask(19, 20);
        pub const CLK_SYS_RESETS: u32 = helpers.generateMask(18, 19);
        pub const CLK_SYS_PWM: u32 = helpers.generateMask(17, 18);
        pub const CLK_SYS_PSM: u32 = helpers.generateMask(16, 17);
        pub const CLK_SYS_PLL_USB: u32 = helpers.generateMask(15, 16);
        pub const CLK_SYS_PLL_SYS: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_PIO1: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_PIO0: u32 = helpers.generateMask(12, 13);
        pub const CLK_SYS_PADS: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_VREG_AND_CHIP_RESET: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_JTAG: u32 = helpers.generateMask(9, 10);
        pub const CLK_SYS_IO: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_I2C1: u32 = helpers.generateMask(7, 8);
        pub const CLK_SYS_I2C0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_DMA: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_BUSFABRIC: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_BUSCTRL: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_ADC: u32 = helpers.generateMask(2, 3);
        pub const CLK_ADC_ADC: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_CLOCKS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CLK_SYS_SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn CLK_SYS_SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn CLK_SYS_SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn CLK_SYS_SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn CLK_SYS_SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn CLK_PERI_SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn CLK_SYS_SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn CLK_PERI_SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn CLK_SYS_SIO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn CLK_SYS_RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn CLK_RTC_RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn CLK_SYS_ROSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn CLK_SYS_ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn CLK_SYS_RESETS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn CLK_SYS_PWM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn CLK_SYS_PSM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn CLK_SYS_PLL_USB(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn CLK_SYS_PLL_SYS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn CLK_SYS_PIO1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn CLK_SYS_PIO0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn CLK_SYS_PADS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn CLK_SYS_VREG_AND_CHIP_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn CLK_SYS_JTAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn CLK_SYS_IO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn CLK_SYS_I2C1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CLK_SYS_I2C0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CLK_SYS_DMA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CLK_SYS_BUSFABRIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CLK_SYS_BUSCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLK_SYS_ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CLK_ADC_ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CLK_SYS_CLOCKS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn CLK_SYS_SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn CLK_SYS_SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn CLK_SYS_SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn CLK_SYS_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn CLK_PERI_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn CLK_SYS_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn CLK_PERI_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn CLK_SYS_SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn CLK_SYS_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn CLK_RTC_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn CLK_SYS_ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn CLK_SYS_ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn CLK_SYS_RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CLK_SYS_PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CLK_SYS_PSM(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn CLK_SYS_PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn CLK_SYS_PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_SYS_PADS(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_SYS_IO(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_SYS_I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_ADC_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CLK_SYS_SRAM3(v: u1) Value {
        return Value.CLK_SYS_SRAM3(.{}, v);
    }
    pub fn CLK_SYS_SRAM2(v: u1) Value {
        return Value.CLK_SYS_SRAM2(.{}, v);
    }
    pub fn CLK_SYS_SRAM1(v: u1) Value {
        return Value.CLK_SYS_SRAM1(.{}, v);
    }
    pub fn CLK_SYS_SRAM0(v: u1) Value {
        return Value.CLK_SYS_SRAM0(.{}, v);
    }
    pub fn CLK_SYS_SPI1(v: u1) Value {
        return Value.CLK_SYS_SPI1(.{}, v);
    }
    pub fn CLK_PERI_SPI1(v: u1) Value {
        return Value.CLK_PERI_SPI1(.{}, v);
    }
    pub fn CLK_SYS_SPI0(v: u1) Value {
        return Value.CLK_SYS_SPI0(.{}, v);
    }
    pub fn CLK_PERI_SPI0(v: u1) Value {
        return Value.CLK_PERI_SPI0(.{}, v);
    }
    pub fn CLK_SYS_SIO(v: u1) Value {
        return Value.CLK_SYS_SIO(.{}, v);
    }
    pub fn CLK_SYS_RTC(v: u1) Value {
        return Value.CLK_SYS_RTC(.{}, v);
    }
    pub fn CLK_RTC_RTC(v: u1) Value {
        return Value.CLK_RTC_RTC(.{}, v);
    }
    pub fn CLK_SYS_ROSC(v: u1) Value {
        return Value.CLK_SYS_ROSC(.{}, v);
    }
    pub fn CLK_SYS_ROM(v: u1) Value {
        return Value.CLK_SYS_ROM(.{}, v);
    }
    pub fn CLK_SYS_RESETS(v: u1) Value {
        return Value.CLK_SYS_RESETS(.{}, v);
    }
    pub fn CLK_SYS_PWM(v: u1) Value {
        return Value.CLK_SYS_PWM(.{}, v);
    }
    pub fn CLK_SYS_PSM(v: u1) Value {
        return Value.CLK_SYS_PSM(.{}, v);
    }
    pub fn CLK_SYS_PLL_USB(v: u1) Value {
        return Value.CLK_SYS_PLL_USB(.{}, v);
    }
    pub fn CLK_SYS_PLL_SYS(v: u1) Value {
        return Value.CLK_SYS_PLL_SYS(.{}, v);
    }
    pub fn CLK_SYS_PIO1(v: u1) Value {
        return Value.CLK_SYS_PIO1(.{}, v);
    }
    pub fn CLK_SYS_PIO0(v: u1) Value {
        return Value.CLK_SYS_PIO0(.{}, v);
    }
    pub fn CLK_SYS_PADS(v: u1) Value {
        return Value.CLK_SYS_PADS(.{}, v);
    }
    pub fn CLK_SYS_VREG_AND_CHIP_RESET(v: u1) Value {
        return Value.CLK_SYS_VREG_AND_CHIP_RESET(.{}, v);
    }
    pub fn CLK_SYS_JTAG(v: u1) Value {
        return Value.CLK_SYS_JTAG(.{}, v);
    }
    pub fn CLK_SYS_IO(v: u1) Value {
        return Value.CLK_SYS_IO(.{}, v);
    }
    pub fn CLK_SYS_I2C1(v: u1) Value {
        return Value.CLK_SYS_I2C1(.{}, v);
    }
    pub fn CLK_SYS_I2C0(v: u1) Value {
        return Value.CLK_SYS_I2C0(.{}, v);
    }
    pub fn CLK_SYS_DMA(v: u1) Value {
        return Value.CLK_SYS_DMA(.{}, v);
    }
    pub fn CLK_SYS_BUSFABRIC(v: u1) Value {
        return Value.CLK_SYS_BUSFABRIC(.{}, v);
    }
    pub fn CLK_SYS_BUSCTRL(v: u1) Value {
        return Value.CLK_SYS_BUSCTRL(.{}, v);
    }
    pub fn CLK_SYS_ADC(v: u1) Value {
        return Value.CLK_SYS_ADC(.{}, v);
    }
    pub fn CLK_ADC_ADC(v: u1) Value {
        return Value.CLK_ADC_ADC(.{}, v);
    }
    pub fn CLK_SYS_CLOCKS(v: u1) Value {
        return Value.CLK_SYS_CLOCKS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// enable clock in wake mode
pub const WAKE_EN1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080a4),
    pub const FieldMasks = struct {
        pub const CLK_SYS_XOSC: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_XIP: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_WATCHDOG: u32 = helpers.generateMask(12, 13);
        pub const CLK_USB_USBCTRL: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_USBCTRL: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_UART1: u32 = helpers.generateMask(9, 10);
        pub const CLK_PERI_UART1: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_UART0: u32 = helpers.generateMask(7, 8);
        pub const CLK_PERI_UART0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_TIMER: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_TBMAN: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_SYSINFO: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_SYSCFG: u32 = helpers.generateMask(2, 3);
        pub const CLK_SYS_SRAM5: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_SRAM4: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CLK_SYS_XOSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn CLK_SYS_XIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn CLK_SYS_WATCHDOG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn CLK_USB_USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn CLK_SYS_USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn CLK_SYS_UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn CLK_PERI_UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn CLK_SYS_UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CLK_PERI_UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CLK_SYS_TIMER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CLK_SYS_TBMAN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CLK_SYS_SYSINFO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLK_SYS_SYSCFG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CLK_SYS_SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CLK_SYS_SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_WATCHDOG(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_USB_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_PERI_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_PERI_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_SYS_SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CLK_SYS_XOSC(v: u1) Value {
        return Value.CLK_SYS_XOSC(.{}, v);
    }
    pub fn CLK_SYS_XIP(v: u1) Value {
        return Value.CLK_SYS_XIP(.{}, v);
    }
    pub fn CLK_SYS_WATCHDOG(v: u1) Value {
        return Value.CLK_SYS_WATCHDOG(.{}, v);
    }
    pub fn CLK_USB_USBCTRL(v: u1) Value {
        return Value.CLK_USB_USBCTRL(.{}, v);
    }
    pub fn CLK_SYS_USBCTRL(v: u1) Value {
        return Value.CLK_SYS_USBCTRL(.{}, v);
    }
    pub fn CLK_SYS_UART1(v: u1) Value {
        return Value.CLK_SYS_UART1(.{}, v);
    }
    pub fn CLK_PERI_UART1(v: u1) Value {
        return Value.CLK_PERI_UART1(.{}, v);
    }
    pub fn CLK_SYS_UART0(v: u1) Value {
        return Value.CLK_SYS_UART0(.{}, v);
    }
    pub fn CLK_PERI_UART0(v: u1) Value {
        return Value.CLK_PERI_UART0(.{}, v);
    }
    pub fn CLK_SYS_TIMER(v: u1) Value {
        return Value.CLK_SYS_TIMER(.{}, v);
    }
    pub fn CLK_SYS_TBMAN(v: u1) Value {
        return Value.CLK_SYS_TBMAN(.{}, v);
    }
    pub fn CLK_SYS_SYSINFO(v: u1) Value {
        return Value.CLK_SYS_SYSINFO(.{}, v);
    }
    pub fn CLK_SYS_SYSCFG(v: u1) Value {
        return Value.CLK_SYS_SYSCFG(.{}, v);
    }
    pub fn CLK_SYS_SRAM5(v: u1) Value {
        return Value.CLK_SYS_SRAM5(.{}, v);
    }
    pub fn CLK_SYS_SRAM4(v: u1) Value {
        return Value.CLK_SYS_SRAM4(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// enable clock in sleep mode
pub const SLEEP_EN0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080a8),
    pub const FieldMasks = struct {
        pub const CLK_SYS_SRAM3: u32 = helpers.generateMask(31, 32);
        pub const CLK_SYS_SRAM2: u32 = helpers.generateMask(30, 31);
        pub const CLK_SYS_SRAM1: u32 = helpers.generateMask(29, 30);
        pub const CLK_SYS_SRAM0: u32 = helpers.generateMask(28, 29);
        pub const CLK_SYS_SPI1: u32 = helpers.generateMask(27, 28);
        pub const CLK_PERI_SPI1: u32 = helpers.generateMask(26, 27);
        pub const CLK_SYS_SPI0: u32 = helpers.generateMask(25, 26);
        pub const CLK_PERI_SPI0: u32 = helpers.generateMask(24, 25);
        pub const CLK_SYS_SIO: u32 = helpers.generateMask(23, 24);
        pub const CLK_SYS_RTC: u32 = helpers.generateMask(22, 23);
        pub const CLK_RTC_RTC: u32 = helpers.generateMask(21, 22);
        pub const CLK_SYS_ROSC: u32 = helpers.generateMask(20, 21);
        pub const CLK_SYS_ROM: u32 = helpers.generateMask(19, 20);
        pub const CLK_SYS_RESETS: u32 = helpers.generateMask(18, 19);
        pub const CLK_SYS_PWM: u32 = helpers.generateMask(17, 18);
        pub const CLK_SYS_PSM: u32 = helpers.generateMask(16, 17);
        pub const CLK_SYS_PLL_USB: u32 = helpers.generateMask(15, 16);
        pub const CLK_SYS_PLL_SYS: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_PIO1: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_PIO0: u32 = helpers.generateMask(12, 13);
        pub const CLK_SYS_PADS: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_VREG_AND_CHIP_RESET: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_JTAG: u32 = helpers.generateMask(9, 10);
        pub const CLK_SYS_IO: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_I2C1: u32 = helpers.generateMask(7, 8);
        pub const CLK_SYS_I2C0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_DMA: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_BUSFABRIC: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_BUSCTRL: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_ADC: u32 = helpers.generateMask(2, 3);
        pub const CLK_ADC_ADC: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_CLOCKS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CLK_SYS_SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn CLK_SYS_SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn CLK_SYS_SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn CLK_SYS_SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn CLK_SYS_SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn CLK_PERI_SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn CLK_SYS_SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn CLK_PERI_SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn CLK_SYS_SIO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn CLK_SYS_RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn CLK_RTC_RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn CLK_SYS_ROSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn CLK_SYS_ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn CLK_SYS_RESETS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn CLK_SYS_PWM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn CLK_SYS_PSM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn CLK_SYS_PLL_USB(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn CLK_SYS_PLL_SYS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn CLK_SYS_PIO1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn CLK_SYS_PIO0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn CLK_SYS_PADS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn CLK_SYS_VREG_AND_CHIP_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn CLK_SYS_JTAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn CLK_SYS_IO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn CLK_SYS_I2C1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CLK_SYS_I2C0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CLK_SYS_DMA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CLK_SYS_BUSFABRIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CLK_SYS_BUSCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLK_SYS_ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CLK_ADC_ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CLK_SYS_CLOCKS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn CLK_SYS_SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn CLK_SYS_SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn CLK_SYS_SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn CLK_SYS_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn CLK_PERI_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn CLK_SYS_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn CLK_PERI_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn CLK_SYS_SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn CLK_SYS_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn CLK_RTC_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn CLK_SYS_ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn CLK_SYS_ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn CLK_SYS_RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CLK_SYS_PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CLK_SYS_PSM(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn CLK_SYS_PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn CLK_SYS_PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_SYS_PADS(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_SYS_IO(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_SYS_I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_ADC_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CLK_SYS_SRAM3(v: u1) Value {
        return Value.CLK_SYS_SRAM3(.{}, v);
    }
    pub fn CLK_SYS_SRAM2(v: u1) Value {
        return Value.CLK_SYS_SRAM2(.{}, v);
    }
    pub fn CLK_SYS_SRAM1(v: u1) Value {
        return Value.CLK_SYS_SRAM1(.{}, v);
    }
    pub fn CLK_SYS_SRAM0(v: u1) Value {
        return Value.CLK_SYS_SRAM0(.{}, v);
    }
    pub fn CLK_SYS_SPI1(v: u1) Value {
        return Value.CLK_SYS_SPI1(.{}, v);
    }
    pub fn CLK_PERI_SPI1(v: u1) Value {
        return Value.CLK_PERI_SPI1(.{}, v);
    }
    pub fn CLK_SYS_SPI0(v: u1) Value {
        return Value.CLK_SYS_SPI0(.{}, v);
    }
    pub fn CLK_PERI_SPI0(v: u1) Value {
        return Value.CLK_PERI_SPI0(.{}, v);
    }
    pub fn CLK_SYS_SIO(v: u1) Value {
        return Value.CLK_SYS_SIO(.{}, v);
    }
    pub fn CLK_SYS_RTC(v: u1) Value {
        return Value.CLK_SYS_RTC(.{}, v);
    }
    pub fn CLK_RTC_RTC(v: u1) Value {
        return Value.CLK_RTC_RTC(.{}, v);
    }
    pub fn CLK_SYS_ROSC(v: u1) Value {
        return Value.CLK_SYS_ROSC(.{}, v);
    }
    pub fn CLK_SYS_ROM(v: u1) Value {
        return Value.CLK_SYS_ROM(.{}, v);
    }
    pub fn CLK_SYS_RESETS(v: u1) Value {
        return Value.CLK_SYS_RESETS(.{}, v);
    }
    pub fn CLK_SYS_PWM(v: u1) Value {
        return Value.CLK_SYS_PWM(.{}, v);
    }
    pub fn CLK_SYS_PSM(v: u1) Value {
        return Value.CLK_SYS_PSM(.{}, v);
    }
    pub fn CLK_SYS_PLL_USB(v: u1) Value {
        return Value.CLK_SYS_PLL_USB(.{}, v);
    }
    pub fn CLK_SYS_PLL_SYS(v: u1) Value {
        return Value.CLK_SYS_PLL_SYS(.{}, v);
    }
    pub fn CLK_SYS_PIO1(v: u1) Value {
        return Value.CLK_SYS_PIO1(.{}, v);
    }
    pub fn CLK_SYS_PIO0(v: u1) Value {
        return Value.CLK_SYS_PIO0(.{}, v);
    }
    pub fn CLK_SYS_PADS(v: u1) Value {
        return Value.CLK_SYS_PADS(.{}, v);
    }
    pub fn CLK_SYS_VREG_AND_CHIP_RESET(v: u1) Value {
        return Value.CLK_SYS_VREG_AND_CHIP_RESET(.{}, v);
    }
    pub fn CLK_SYS_JTAG(v: u1) Value {
        return Value.CLK_SYS_JTAG(.{}, v);
    }
    pub fn CLK_SYS_IO(v: u1) Value {
        return Value.CLK_SYS_IO(.{}, v);
    }
    pub fn CLK_SYS_I2C1(v: u1) Value {
        return Value.CLK_SYS_I2C1(.{}, v);
    }
    pub fn CLK_SYS_I2C0(v: u1) Value {
        return Value.CLK_SYS_I2C0(.{}, v);
    }
    pub fn CLK_SYS_DMA(v: u1) Value {
        return Value.CLK_SYS_DMA(.{}, v);
    }
    pub fn CLK_SYS_BUSFABRIC(v: u1) Value {
        return Value.CLK_SYS_BUSFABRIC(.{}, v);
    }
    pub fn CLK_SYS_BUSCTRL(v: u1) Value {
        return Value.CLK_SYS_BUSCTRL(.{}, v);
    }
    pub fn CLK_SYS_ADC(v: u1) Value {
        return Value.CLK_SYS_ADC(.{}, v);
    }
    pub fn CLK_ADC_ADC(v: u1) Value {
        return Value.CLK_ADC_ADC(.{}, v);
    }
    pub fn CLK_SYS_CLOCKS(v: u1) Value {
        return Value.CLK_SYS_CLOCKS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// enable clock in sleep mode
pub const SLEEP_EN1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080ac),
    pub const FieldMasks = struct {
        pub const CLK_SYS_XOSC: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_XIP: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_WATCHDOG: u32 = helpers.generateMask(12, 13);
        pub const CLK_USB_USBCTRL: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_USBCTRL: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_UART1: u32 = helpers.generateMask(9, 10);
        pub const CLK_PERI_UART1: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_UART0: u32 = helpers.generateMask(7, 8);
        pub const CLK_PERI_UART0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_TIMER: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_TBMAN: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_SYSINFO: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_SYSCFG: u32 = helpers.generateMask(2, 3);
        pub const CLK_SYS_SRAM5: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_SRAM4: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CLK_SYS_XOSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn CLK_SYS_XIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn CLK_SYS_WATCHDOG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn CLK_USB_USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn CLK_SYS_USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn CLK_SYS_UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn CLK_PERI_UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn CLK_SYS_UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CLK_PERI_UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CLK_SYS_TIMER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CLK_SYS_TBMAN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CLK_SYS_SYSINFO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLK_SYS_SYSCFG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CLK_SYS_SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CLK_SYS_SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_WATCHDOG(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_USB_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_PERI_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_PERI_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_SYS_SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CLK_SYS_XOSC(v: u1) Value {
        return Value.CLK_SYS_XOSC(.{}, v);
    }
    pub fn CLK_SYS_XIP(v: u1) Value {
        return Value.CLK_SYS_XIP(.{}, v);
    }
    pub fn CLK_SYS_WATCHDOG(v: u1) Value {
        return Value.CLK_SYS_WATCHDOG(.{}, v);
    }
    pub fn CLK_USB_USBCTRL(v: u1) Value {
        return Value.CLK_USB_USBCTRL(.{}, v);
    }
    pub fn CLK_SYS_USBCTRL(v: u1) Value {
        return Value.CLK_SYS_USBCTRL(.{}, v);
    }
    pub fn CLK_SYS_UART1(v: u1) Value {
        return Value.CLK_SYS_UART1(.{}, v);
    }
    pub fn CLK_PERI_UART1(v: u1) Value {
        return Value.CLK_PERI_UART1(.{}, v);
    }
    pub fn CLK_SYS_UART0(v: u1) Value {
        return Value.CLK_SYS_UART0(.{}, v);
    }
    pub fn CLK_PERI_UART0(v: u1) Value {
        return Value.CLK_PERI_UART0(.{}, v);
    }
    pub fn CLK_SYS_TIMER(v: u1) Value {
        return Value.CLK_SYS_TIMER(.{}, v);
    }
    pub fn CLK_SYS_TBMAN(v: u1) Value {
        return Value.CLK_SYS_TBMAN(.{}, v);
    }
    pub fn CLK_SYS_SYSINFO(v: u1) Value {
        return Value.CLK_SYS_SYSINFO(.{}, v);
    }
    pub fn CLK_SYS_SYSCFG(v: u1) Value {
        return Value.CLK_SYS_SYSCFG(.{}, v);
    }
    pub fn CLK_SYS_SRAM5(v: u1) Value {
        return Value.CLK_SYS_SRAM5(.{}, v);
    }
    pub fn CLK_SYS_SRAM4(v: u1) Value {
        return Value.CLK_SYS_SRAM4(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// indicates the state of the clock enable
pub const ENABLED0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080b0),
    pub const FieldMasks = struct {
        pub const CLK_SYS_SRAM3: u32 = helpers.generateMask(31, 32);
        pub const CLK_SYS_SRAM2: u32 = helpers.generateMask(30, 31);
        pub const CLK_SYS_SRAM1: u32 = helpers.generateMask(29, 30);
        pub const CLK_SYS_SRAM0: u32 = helpers.generateMask(28, 29);
        pub const CLK_SYS_SPI1: u32 = helpers.generateMask(27, 28);
        pub const CLK_PERI_SPI1: u32 = helpers.generateMask(26, 27);
        pub const CLK_SYS_SPI0: u32 = helpers.generateMask(25, 26);
        pub const CLK_PERI_SPI0: u32 = helpers.generateMask(24, 25);
        pub const CLK_SYS_SIO: u32 = helpers.generateMask(23, 24);
        pub const CLK_SYS_RTC: u32 = helpers.generateMask(22, 23);
        pub const CLK_RTC_RTC: u32 = helpers.generateMask(21, 22);
        pub const CLK_SYS_ROSC: u32 = helpers.generateMask(20, 21);
        pub const CLK_SYS_ROM: u32 = helpers.generateMask(19, 20);
        pub const CLK_SYS_RESETS: u32 = helpers.generateMask(18, 19);
        pub const CLK_SYS_PWM: u32 = helpers.generateMask(17, 18);
        pub const CLK_SYS_PSM: u32 = helpers.generateMask(16, 17);
        pub const CLK_SYS_PLL_USB: u32 = helpers.generateMask(15, 16);
        pub const CLK_SYS_PLL_SYS: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_PIO1: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_PIO0: u32 = helpers.generateMask(12, 13);
        pub const CLK_SYS_PADS: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_VREG_AND_CHIP_RESET: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_JTAG: u32 = helpers.generateMask(9, 10);
        pub const CLK_SYS_IO: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_I2C1: u32 = helpers.generateMask(7, 8);
        pub const CLK_SYS_I2C0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_DMA: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_BUSFABRIC: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_BUSCTRL: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_ADC: u32 = helpers.generateMask(2, 3);
        pub const CLK_ADC_ADC: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_CLOCKS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn CLK_SYS_SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn CLK_SYS_SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn CLK_SYS_SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn CLK_SYS_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn CLK_PERI_SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn CLK_SYS_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn CLK_PERI_SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn CLK_SYS_SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn CLK_SYS_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn CLK_RTC_RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn CLK_SYS_ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn CLK_SYS_ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn CLK_SYS_RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CLK_SYS_PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CLK_SYS_PSM(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn CLK_SYS_PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn CLK_SYS_PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_SYS_PADS(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_SYS_IO(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_SYS_I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_ADC_ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// indicates the state of the clock enable
pub const ENABLED1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080b4),
    pub const FieldMasks = struct {
        pub const CLK_SYS_XOSC: u32 = helpers.generateMask(14, 15);
        pub const CLK_SYS_XIP: u32 = helpers.generateMask(13, 14);
        pub const CLK_SYS_WATCHDOG: u32 = helpers.generateMask(12, 13);
        pub const CLK_USB_USBCTRL: u32 = helpers.generateMask(11, 12);
        pub const CLK_SYS_USBCTRL: u32 = helpers.generateMask(10, 11);
        pub const CLK_SYS_UART1: u32 = helpers.generateMask(9, 10);
        pub const CLK_PERI_UART1: u32 = helpers.generateMask(8, 9);
        pub const CLK_SYS_UART0: u32 = helpers.generateMask(7, 8);
        pub const CLK_PERI_UART0: u32 = helpers.generateMask(6, 7);
        pub const CLK_SYS_TIMER: u32 = helpers.generateMask(5, 6);
        pub const CLK_SYS_TBMAN: u32 = helpers.generateMask(4, 5);
        pub const CLK_SYS_SYSINFO: u32 = helpers.generateMask(3, 4);
        pub const CLK_SYS_SYSCFG: u32 = helpers.generateMask(2, 3);
        pub const CLK_SYS_SRAM5: u32 = helpers.generateMask(1, 2);
        pub const CLK_SYS_SRAM4: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn CLK_SYS_XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn CLK_SYS_XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn CLK_SYS_WATCHDOG(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn CLK_USB_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn CLK_SYS_USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn CLK_SYS_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CLK_PERI_UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn CLK_SYS_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CLK_PERI_UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CLK_SYS_TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CLK_SYS_TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CLK_SYS_SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLK_SYS_SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CLK_SYS_SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CLK_SYS_SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080b8),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Interrupt Enable
pub const INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080bc),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Interrupt Force
pub const INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080c0),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Interrupt status after masking &amp; forcing
pub const INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400080c4),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const CLOCKS_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40008000),

    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_GPOUT0_CTRL: CLK_GPOUT0_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_GPOUT0_DIV: CLK_GPOUT0_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_GPOUT0_SELECTED: CLK_GPOUT0_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_GPOUT1_CTRL: CLK_GPOUT1_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_GPOUT1_DIV: CLK_GPOUT1_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_GPOUT1_SELECTED: CLK_GPOUT1_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_GPOUT2_CTRL: CLK_GPOUT2_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_GPOUT2_DIV: CLK_GPOUT2_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_GPOUT2_SELECTED: CLK_GPOUT2_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_GPOUT3_CTRL: CLK_GPOUT3_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_GPOUT3_DIV: CLK_GPOUT3_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_GPOUT3_SELECTED: CLK_GPOUT3_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_REF_CTRL: CLK_REF_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_REF_DIV: CLK_REF_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_REF_SELECTED: CLK_REF_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_SYS_CTRL: CLK_SYS_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_SYS_DIV: CLK_SYS_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_SYS_SELECTED: CLK_SYS_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_PERI_CTRL: CLK_PERI_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_PERI_DIV: CLK_PERI_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_PERI_SELECTED: CLK_PERI_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_USB_CTRL: CLK_USB_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_USB_DIV: CLK_USB_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_USB_SELECTED: CLK_USB_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_ADC_CTRL: CLK_ADC_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_ADC_DIV: CLK_ADC_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_ADC_SELECTED: CLK_ADC_SELECTED = .{},
    /// Clock control, can be changed on-the-fly (except for auxsrc)
    CLK_RTC_CTRL: CLK_RTC_CTRL = .{},
    /// Clock divisor, can be changed on-the-fly
    CLK_RTC_DIV: CLK_RTC_DIV = .{},
    /// Indicates which SRC is currently selected by the glitchless mux (one-hot).
    CLK_RTC_SELECTED: CLK_RTC_SELECTED = .{},
    CLK_SYS_RESUS_CTRL: CLK_SYS_RESUS_CTRL = .{},
    CLK_SYS_RESUS_STATUS: CLK_SYS_RESUS_STATUS = .{},
    /// Reference clock frequency in kHz
    FC0_REF_KHZ: FC0_REF_KHZ = .{},
    /// Minimum pass frequency in kHz. This is optional. Set to 0 if you are not using the pass/fail flags
    FC0_MIN_KHZ: FC0_MIN_KHZ = .{},
    /// Maximum pass frequency in kHz. This is optional. Set to 0x1ffffff if you are not using the pass/fail flags
    FC0_MAX_KHZ: FC0_MAX_KHZ = .{},
    /// Delays the start of frequency counting to allow the mux to settle
    /// Delay is measured in multiples of the reference clock period
    FC0_DELAY: FC0_DELAY = .{},
    /// The test interval is 0.98us * 2**interval, but let&#39;s call it 1us * 2**interval
    /// The default gives a test interval of 250us
    FC0_INTERVAL: FC0_INTERVAL = .{},
    /// Clock sent to frequency counter, set to 0 when not required
    /// Writing to this register initiates the frequency count
    FC0_SRC: FC0_SRC = .{},
    /// Frequency counter status
    FC0_STATUS: FC0_STATUS = .{},
    /// Result of frequency measurement, only valid when status_done=1
    FC0_RESULT: FC0_RESULT = .{},
    /// enable clock in wake mode
    WAKE_EN0: WAKE_EN0 = .{},
    /// enable clock in wake mode
    WAKE_EN1: WAKE_EN1 = .{},
    /// enable clock in sleep mode
    SLEEP_EN0: SLEEP_EN0 = .{},
    /// enable clock in sleep mode
    SLEEP_EN1: SLEEP_EN1 = .{},
    /// indicates the state of the clock enable
    ENABLED0: ENABLED0 = .{},
    /// indicates the state of the clock enable
    ENABLED1: ENABLED1 = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const CLOCKS = CLOCKS_p{};
