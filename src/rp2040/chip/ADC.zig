const helpers = @import("helpers.zig");
/// ADC Control and Status
pub const CS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c000),
    pub const FieldMasks = struct {
        pub const RROBIN: u32 = helpers.generateMask(16, 21);
        pub const AINSEL: u32 = helpers.generateMask(12, 15);
        pub const ERR_STICKY: u32 = helpers.generateMask(10, 11);
        pub const ERR: u32 = helpers.generateMask(9, 10);
        pub const READY: u32 = helpers.generateMask(8, 9);
        pub const START_MANY: u32 = helpers.generateMask(3, 4);
        pub const START_ONCE: u32 = helpers.generateMask(2, 3);
        pub const TS_EN: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Round-robin sampling. 1 bit per channel. Set all bits to 0 to disable.
        /// Otherwise, the ADC will cycle through each enabled channel in a round-robin fashion.
        /// The first channel to be sampled will be the one currently indicated by AINSEL.
        /// AINSEL will be updated after each conversion with the newly-selected channel.
        pub fn RROBIN(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 21),
            };
        }
        /// Select analog mux input. Updated automatically in round-robin mode.
        pub fn AINSEL(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 15),
            };
        }
        /// Some past ADC conversion encountered an error. Write 1 to clear.
        pub fn ERR_STICKY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Continuously perform conversions whilst this bit is 1. A new conversion will start immediately after the previous finishes.
        pub fn START_MANY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Start a single conversion. Self-clearing. Ignored if start_many is asserted.
        pub fn START_ONCE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Power on temperature sensor. 1 - enabled. 0 - disabled.
        pub fn TS_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Power on ADC and enable its clock.
        /// 1 - enabled. 0 - disabled.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn RROBIN(self: Result) u5 {
            const mask = comptime helpers.generateMask(16, 21);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn AINSEL(self: Result) u3 {
            const mask = comptime helpers.generateMask(12, 15);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn ERR_STICKY(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ERR(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn READY(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn START_MANY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn TS_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Round-robin sampling. 1 bit per channel. Set all bits to 0 to disable.
    /// Otherwise, the ADC will cycle through each enabled channel in a round-robin fashion.
    /// The first channel to be sampled will be the one currently indicated by AINSEL.
    /// AINSEL will be updated after each conversion with the newly-selected channel.
    pub fn RROBIN(v: u5) Value {
        return Value.RROBIN(.{}, v);
    }
    /// Select analog mux input. Updated automatically in round-robin mode.
    pub fn AINSEL(v: u3) Value {
        return Value.AINSEL(.{}, v);
    }
    /// Some past ADC conversion encountered an error. Write 1 to clear.
    pub fn ERR_STICKY(v: u1) Value {
        return Value.ERR_STICKY(.{}, v);
    }
    /// Continuously perform conversions whilst this bit is 1. A new conversion will start immediately after the previous finishes.
    pub fn START_MANY(v: u1) Value {
        return Value.START_MANY(.{}, v);
    }
    /// Start a single conversion. Self-clearing. Ignored if start_many is asserted.
    pub fn START_ONCE(v: u1) Value {
        return Value.START_ONCE(.{}, v);
    }
    /// Power on temperature sensor. 1 - enabled. 0 - disabled.
    pub fn TS_EN(v: u1) Value {
        return Value.TS_EN(.{}, v);
    }
    /// Power on ADC and enable its clock.
    /// 1 - enabled. 0 - disabled.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// Result of most recent ADC conversion
pub const RESULT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c004),
    pub fn write(self: @This(), v: u12) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u12) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u12 {
        const mask = comptime helpers.generateMask(0, 12);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// FIFO control and status
pub const FCS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c008),
    pub const FieldMasks = struct {
        pub const THRESH: u32 = helpers.generateMask(24, 28);
        pub const LEVEL: u32 = helpers.generateMask(16, 20);
        pub const OVER: u32 = helpers.generateMask(11, 12);
        pub const UNDER: u32 = helpers.generateMask(10, 11);
        pub const FULL: u32 = helpers.generateMask(9, 10);
        pub const EMPTY: u32 = helpers.generateMask(8, 9);
        pub const DREQ_EN: u32 = helpers.generateMask(3, 4);
        pub const ERR: u32 = helpers.generateMask(2, 3);
        pub const SHIFT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// DREQ/IRQ asserted when level &gt;= threshold
        pub fn THRESH(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 28),
            };
        }
        /// 1 if the FIFO has been overflowed. Write 1 to clear.
        pub fn OVER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// 1 if the FIFO has been underflowed. Write 1 to clear.
        pub fn UNDER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// If 1: assert DMA requests when FIFO contains data
        pub fn DREQ_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// If 1: conversion error bit appears in the FIFO alongside the result
        pub fn ERR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// If 1: FIFO results are right-shifted to be one byte in size. Enables DMA to byte buffers.
        pub fn SHIFT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// If 1: write result to the FIFO after each conversion.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn THRESH(self: Result) u4 {
            const mask = comptime helpers.generateMask(24, 28);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn LEVEL(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn OVER(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn UNDER(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn FULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DREQ_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ERR(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SHIFT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// DREQ/IRQ asserted when level &gt;= threshold
    pub fn THRESH(v: u4) Value {
        return Value.THRESH(.{}, v);
    }
    /// 1 if the FIFO has been overflowed. Write 1 to clear.
    pub fn OVER(v: u1) Value {
        return Value.OVER(.{}, v);
    }
    /// 1 if the FIFO has been underflowed. Write 1 to clear.
    pub fn UNDER(v: u1) Value {
        return Value.UNDER(.{}, v);
    }
    /// If 1: assert DMA requests when FIFO contains data
    pub fn DREQ_EN(v: u1) Value {
        return Value.DREQ_EN(.{}, v);
    }
    /// If 1: conversion error bit appears in the FIFO alongside the result
    pub fn ERR(v: u1) Value {
        return Value.ERR(.{}, v);
    }
    /// If 1: FIFO results are right-shifted to be one byte in size. Enables DMA to byte buffers.
    pub fn SHIFT(v: u1) Value {
        return Value.SHIFT(.{}, v);
    }
    /// If 1: write result to the FIFO after each conversion.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// Conversion result FIFO
pub const FIFO = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c00c),
    pub const FieldMasks = struct {
        pub const ERR: u32 = helpers.generateMask(15, 16);
        pub const VAL: u32 = helpers.generateMask(0, 12);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn ERR(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn VAL(self: Result) u12 {
            const mask = comptime helpers.generateMask(0, 12);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// Clock divider. If non-zero, CS_START_MANY will start conversions
/// at regular intervals rather than back-to-back.
/// The divider is reset when either of these fields are written.
/// Total period is 1 + INT + FRAC / 256
pub const DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c010),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(8, 24);
        pub const FRAC: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Integer part of clock divisor.
        pub fn INT(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 24),
            };
        }
        /// Fractional part of clock divisor. First-order delta-sigma.
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u16 {
            const mask = comptime helpers.generateMask(8, 24);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Integer part of clock divisor.
    pub fn INT(v: u16) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional part of clock divisor. First-order delta-sigma.
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c014),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c018),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c01c),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x4004c020),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Control and data interface to SAR ADC
pub const ADC_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4004c000),

    /// ADC Control and Status
    CS: CS = .{},
    /// Result of most recent ADC conversion
    RESULT: RESULT = .{},
    /// FIFO control and status
    FCS: FCS = .{},
    /// Conversion result FIFO
    FIFO: FIFO = .{},
    /// Clock divider. If non-zero, CS_START_MANY will start conversions
    /// at regular intervals rather than back-to-back.
    /// The divider is reset when either of these fields are written.
    /// Total period is 1 + INT + FRAC / 256
    DIV: DIV = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const ADC = ADC_p{};
